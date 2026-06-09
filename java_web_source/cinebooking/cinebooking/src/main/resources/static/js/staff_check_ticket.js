(() => {
  const $ = (id) => document.getElementById(id);

  // UI
  const camHint = $("camHint");
  const qrRaw = $("qrRaw");
  const ticketCode = $("ticketCode");
  const resultText = $("resultText");

  const btnStartCam = $("btnStartCam");
  const btnStopCam  = $("btnStopCam");
  const btnUseQr    = $("btnUseQr");

  const btnVerify = $("btnVerify");
  const btnCheckin = $("btnCheckin");

  const btnPing = $("btnPing");
  const btnReload = $("btnReload");
  const btnLogout = $("btnLogout");

  const staffName = $("staffName");
  const staffRole = $("staffRole");
  const avatar = $("avatar");

  // ===== Auth helpers =====
  function getToken() {
    return localStorage.getItem("cine_token") || sessionStorage.getItem("cine_token")
      || localStorage.getItem("cb_staff_token") || sessionStorage.getItem("cb_staff_token")
      || localStorage.getItem("token") || sessionStorage.getItem("token");
  }
  function getRole() {
    return localStorage.getItem("cine_role") || sessionStorage.getItem("cine_role")
      || localStorage.getItem("cb_staff_role") || sessionStorage.getItem("cb_staff_role")
      || "ROLE_STAFF";
  }
  function getStaffName() {
    return localStorage.getItem("cine_staffName") || sessionStorage.getItem("cine_staffName")
      || localStorage.getItem("cb_staff_name") || sessionStorage.getItem("cb_staff_name")
      || "Staff";
  }
  function authHeaders() {
    const t = getToken();
    return t ? { "Authorization": "Bearer " + t } : {};
  }
  function clearAuth() {
    [
      "cine_token","cine_role","cine_staffName",
      "cb_staff_token","cb_staff_role","cb_staff_name",
      "token"
    ].forEach(k => {
      localStorage.removeItem(k);
      sessionStorage.removeItem(k);
    });
  }

  // ===== API endpoints =====
  const API_PING = "/api/staff/ping";
  const API_VERIFY = (code) => `/api/staff/tickets/verify?code=${encodeURIComponent(code)}`;
  const API_CHECKIN = "/api/staff/tickets/check-in";

  // ===== Helpers =====
  function setHint(text) {
    if (camHint) camHint.textContent = text || "";
  }
  function setResult(text) {
    if (resultText) resultText.textContent = text || "";
  }

  // =======================================================
  // ✅ Logs (localStorage) - staff_dashboard đọc cái này
  // =======================================================
  const LOG_KEY = "cine_staff_logs";

  function readLogs() {
    try { return JSON.parse(localStorage.getItem(LOG_KEY) || "[]"); }
    catch { return []; }
  }
  function writeLogs(arr) {
    localStorage.setItem(LOG_KEY, JSON.stringify(arr));
  }
  function addLog(action, code, ok, note) {
    const logs = readLogs();
    logs.push({
      ts: Date.now(),
      action: action || "",
      ticketCode: code || "",
      ok: !!ok,
      note: note || ""
    });
    writeLogs(logs.slice(-200));
  }

  // =======================================================
  // ✅ QR SCAN: html5-qrcode (FIX: quét xong vẫn quét tiếp)
  // =======================================================
  let qrScanner = null;
  let isRunning = false;

  // chống spam / treo scan
  let lastText = "";
  let lastAt = 0;
  const COOLDOWN_MS = 1200;

  // quan trọng: tránh callback onSuccess chạy chồng nhau
  let handling = false;

  function setCamButtons(running) {
    if (btnStartCam) btnStartCam.disabled = !!running;
    if (btnStopCam)  btnStopCam.disabled = !running;
  }

  async function stopCamera() {
    try {
      if (qrScanner) {
        // nếu đang pause thì resume trước rồi stop (ổn định hơn)
        try { await qrScanner.resume?.(); } catch {}
        await qrScanner.stop().catch(() => {});
        await qrScanner.clear?.().catch?.(() => {});
        qrScanner = null;
      }
    } finally {
      isRunning = false;
      handling = false;
      lastText = "";
      lastAt = 0;
      setCamButtons(false);
      setHint("Chưa bật camera");
    }
  }

  async function startCamera() {
    const qrBox = $("qr-reader");
    if (!qrBox) {
      setResult("❌ Không tìm thấy vùng quét QR (#qr-reader).");
      return;
    }

    if (!window.Html5Qrcode) {
      setResult("❌ Chưa load thư viện html5-qrcode. Hãy thêm:\n<script src=\"https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js\"></script>");
      return;
    }

    // nếu đang chạy rồi thì không tạo instance mới
    if (isRunning && qrScanner) {
      setHint("Camera đang bật (sẵn sàng quét)");
      return;
    }

    // bật lại sạch sẽ
    await stopCamera();

    setCamButtons(true);
    setHint("Đang bật camera...");

    qrScanner = new Html5Qrcode("qr-reader");

    qrScanner.start(
      { facingMode: "environment" },
      { fps: 12, qrbox: 240 },
      async (decodedText) => {
        const text = String(decodedText || "").trim();
        if (!text) return;

        const now = Date.now();
        if (text === lastText && (now - lastAt) < COOLDOWN_MS) return;

        // tránh chạy chồng callback
        if (handling) return;
        handling = true;

        lastText = text;
        lastAt = now;

        if (qrRaw) qrRaw.value = text;
        if (ticketCode) ticketCode.value = text;

        setResult(" Đã quét thành c: " + text + "\n Sẵn sàng quét vé tiếp theo...");
        setHint("Đã đọc QR (đang chuẩn bị quét tiếp...)");

        // ✅ FIX CHÍNH: pause ngắn rồi resume để quét QR khác
        try { await qrScanner.pause(true); } catch {}

        setTimeout(async () => {
          try { await qrScanner.resume(); } catch {}
          handling = false;
          setHint("Sẵn sàng (đưa QR tiếp theo vào khung)");
        }, 600);
      },
      () => {} // ignore per-frame decode errors
    ).then(() => {
      isRunning = true;
      setCamButtons(true);
      setHint("Sẵn sàng (đưa QR vào khung)");
    }).catch(async (err) => {
      setResult("❌ Không bật được camera: " + err);
      setHint("Lỗi camera");
      await stopCamera();
    });
  }

  // =======================================================
  // ✅ Verify / Check-in
  // =======================================================
  async function verify() {
    const code = (ticketCode?.value || "").trim();
    if (!code) {
      setResult("❌ Vui lòng nhập ticketCode");
      addLog("VERIFY", code, false, "Thiếu ticketCode");
      return;
    }

    const token = getToken();
    if (!token) {
      setResult("❌ Chưa có token staff. Hãy đăng nhập.");
      addLog("VERIFY", code, false, "Chưa có token");
      return;
    }

    try {
      const res = await fetch(API_VERIFY(code), { method: "GET", headers: authHeaders() });
      const text = await res.text();

      if (!res.ok) {
        addLog("VERIFY", code, false, `HTTP ${res.status}`);
        throw new Error(`HTTP ${res.status}\n${text}`);
      }

      let data;
      try { data = JSON.parse(text); } catch { data = text; }

      setResult("✅ VERIFY OK\n" + (typeof data === "string" ? data : JSON.stringify(data, null, 2)));
      addLog("VERIFY", code, true, "OK");
    } catch (e) {
      setResult("❌ VERIFY FAIL\n" + (e?.message || e));
      addLog("VERIFY", code, false, String(e?.message || "FAIL").slice(0, 180));
    }
  }

  async function checkin() {
    const code = (ticketCode?.value || "").trim();
    if (!code) {
      setResult("❌ Vui lòng nhập ticketCode");
      addLog("CHECKIN", code, false, "Thiếu ticketCode");
      return;
    }

    const token = getToken();
    if (!token) {
      setResult("❌ Chưa có token staff. Hãy đăng nhập.");
      addLog("CHECKIN", code, false, "Chưa có token");
      return;
    }

    try {
      const res = await fetch(API_CHECKIN, {
        method: "POST",
        headers: { "Content-Type": "application/json", ...authHeaders() },
        body: JSON.stringify({ ticketCode: code })
      });

      const text = await res.text();

      if (!res.ok) {
        addLog("CHECKIN", code, false, `HTTP ${res.status}`);
        throw new Error(`HTTP ${res.status}\n${text}`);
      }

      let data;
      try { data = JSON.parse(text); } catch { data = text; }

      setResult("✅ CHECK-IN OK\n" + (typeof data === "string" ? data : JSON.stringify(data, null, 2)));
      addLog("CHECKIN", code, true, "OK");
    } catch (e) {
      setResult("❌ CHECK-IN FAIL\n" + (e?.message || e));
      addLog("CHECKIN", code, false, String(e?.message || "FAIL").slice(0, 180));
    }
  }

  async function ping() {
    const token = getToken();
    if (!token) return setResult("❌ Chưa có token staff.");

    try {
      const res = await fetch(API_PING, { headers: authHeaders() });
      const text = await res.text();
      if (!res.ok) throw new Error(`HTTP ${res.status}\n${text}`);
      setResult("✅ TOKEN OK\n" + text);
    } catch (e) {
      setResult("❌ TOKEN FAIL\n" + (e?.message || e));
    }
  }

  // ===== Use QR vừa quét =====
  btnUseQr?.addEventListener("click", () => {
    const raw = (qrRaw?.value || "").trim();
    if (!raw) {
      setResult("⚠️ Chưa có nội dung QR. Hãy bấm 'Bật camera' và đưa QR vào khung.");
      return;
    }
    ticketCode.value = raw;
    setResult("✅ Đã lấy QR → ticketCode");
  });

  // ===== Bind events =====
  btnStartCam?.addEventListener("click", startCamera);
  btnStopCam?.addEventListener("click", stopCamera);

  btnVerify?.addEventListener("click", verify);
  btnCheckin?.addEventListener("click", checkin);

  btnPing?.addEventListener("click", ping);
  btnReload?.addEventListener("click", () => location.reload());
  btnLogout?.addEventListener("click", async () => {
    await stopCamera();
    clearAuth();
    location.href = "/staff/staff_login.html";
  });

  // ===== Init profile =====
  (function initProfile() {
    const name = getStaffName();
    const role = getRole();
    if (staffName) staffName.textContent = name;
    if (staffRole) staffRole.textContent = role;
    if (avatar) avatar.textContent = (name || "S").trim().charAt(0).toUpperCase();
  })();

  setCamButtons(false);
  setHint("Chưa bật camera");

  window.addEventListener("beforeunload", () => {
    try { stopCamera(); } catch {}
  });
})();
