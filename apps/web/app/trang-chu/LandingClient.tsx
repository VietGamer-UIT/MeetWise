"use client";
import { motion } from "framer-motion";
import Link from "next/link";
import {
  Zap, CheckCircle2, XCircle, ArrowRight, Shield,
  Globe, BarChart3, Bell, Sparkles,
} from "lucide-react";

// ─── Variants Framer Motion ───────────────────────────────────

const fadeUp = {
  initial: { opacity: 0, y: 30 },
  animate: { opacity: 1, y: 0 },
};

const fadeIn = {
  initial: { opacity: 0 },
  animate: { opacity: 1 },
};

const stagger = {
  animate: { transition: { staggerChildren: 0.12 } },
};

const staggerFast = {
  animate: { transition: { staggerChildren: 0.08 } },
};

const scaleIn = {
  initial: { opacity: 0, scale: 0.92 },
  animate: { opacity: 1, scale: 1 },
};

const easeOut = { duration: 0.5, ease: "easeOut" as const };
const easeOutFast = { duration: 0.35, ease: "easeOut" as const };

// ─── Dữ liệu ─────────────────────────────────────────────────

const features = [
  {
    icon: Sparkles,
    color: "text-violet-400",
    bg: "bg-violet-500/10 border-violet-500/20",
    title: "AI Neuro-Symbolic",
    desc: "Kết hợp LLM (Gemini) để hiểu tiếng Việt tự nhiên và Z3 Theorem Prover để đảm bảo kết quả chính xác 100% — không đoán mò.",
  },
  {
    icon: Shield,
    color: "text-blue-400",
    bg: "bg-blue-500/10 border-blue-500/20",
    title: "Zero Hallucination",
    desc: "Z3 SMT Solver xác minh logic toán học. Kết quả READY hoặc RESCHEDULED luôn tất định, không bao giờ ngẫu nhiên.",
  },
  {
    icon: Globe,
    color: "text-green-400",
    bg: "bg-green-500/10 border-green-500/20",
    title: "Tiếng Việt Native",
    desc: "Viết điều kiện họp bằng tiếng Việt tự nhiên. Ví dụ: \"Slide cập nhật hoặc Sheet chốt số, bắt buộc Manager rảnh\".",
  },
  {
    icon: BarChart3,
    color: "text-yellow-400",
    bg: "bg-yellow-500/10 border-yellow-500/20",
    title: "Dashboard Analytics",
    desc: "Xem tỉ lệ sẵn sàng, xu hướng cuộc họp và thống kê tổng quan của cả đội ngay trên dashboard trực quan.",
  },
  {
    icon: Bell,
    color: "text-pink-400",
    bg: "bg-pink-500/10 border-pink-500/20",
    title: "Thông Báo Tự Động",
    desc: "Tự động gửi email khi cuộc họp cần dời lịch. Tích hợp Google Workspace (Calendar, Chat, Drive).",
  },
  {
    icon: Zap,
    color: "text-orange-400",
    bg: "bg-orange-500/10 border-orange-500/20",
    title: "Siêu Nhanh",
    desc: "Đánh giá hoàn tất trong vòng dưới 100ms với fallback parser. Không phụ thuộc vào tốc độ LLM.",
  },
];

const howItWorks = [
  {
    step: "01",
    title: "Nhập điều kiện họp",
    desc: "Bạn tạo cuộc họp và nhập điều kiện bằng tiếng Việt. Ví dụ: \"Slide phải xong VÀ Manager phải rảnh\".",
  },
  {
    step: "02",
    title: "AI phân tích",
    desc: "Gemini AI đọc và hiểu điều kiện của bạn, sau đó Z3 Theorem Prover xác minh logic một cách chính xác tuyệt đối.",
  },
  {
    step: "03",
    title: "Nhận kết quả ngay",
    desc: "Hệ thống trả lời: ✅ Sẵn sàng họp hoặc ⚠️ Cần dời lịch — kèm lý do cụ thể và đề xuất lịch mới.",
  },
];

// ─── Component ────────────────────────────────────────────────

export default function LandingClient() {
  return (
    <div className="min-h-screen overflow-x-hidden">
      {/* === Orbs nền === */}
      <div className="fixed inset-0 pointer-events-none overflow-hidden -z-10">
        <motion.div
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 1.5, ease: "easeOut" }}
          className="absolute -top-60 -right-60 w-[600px] h-[600px] bg-violet-600/15 rounded-full blur-3xl"
        />
        <motion.div
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 1.5, delay: 0.3, ease: "easeOut" }}
          className="absolute -bottom-60 -left-60 w-[600px] h-[600px] bg-blue-600/10 rounded-full blur-3xl"
        />
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 2, delay: 0.6 }}
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-violet-500/5 rounded-full blur-3xl"
        />
      </div>

      {/* === Navbar === */}
      <motion.nav
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, ease: "easeOut" }}
        className="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 py-4 backdrop-blur-md bg-black/20 border-b border-white/[0.06]"
      >
        <Link href="/" className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-xl bg-gradient-to-br from-violet-500 to-violet-700 flex items-center justify-center shadow-lg shadow-violet-500/30">
            <Zap size={16} className="text-white" />
          </div>
          <span className="text-lg font-bold gradient-text">MeetWise</span>
        </Link>

        <div className="flex items-center gap-3">
          <Link href="/dang-nhap" className="btn-secondary text-sm py-1.5 px-4 hidden sm:inline-flex">
            Đăng nhập
          </Link>
          <Link href="/dang-ky" className="btn-primary text-sm py-1.5 px-4">
            Dùng miễn phí
          </Link>
        </div>
      </motion.nav>

      {/* === Hero Section === */}
      <section className="pt-36 pb-24 px-6 text-center">
        <motion.div
          variants={stagger}
          initial="initial"
          animate="animate"
          className="max-w-4xl mx-auto"
        >
          {/* Badge */}
          <motion.div variants={fadeUp} transition={easeOut}>
            <span className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-violet-500/10 border border-violet-500/20 text-violet-400 text-sm font-medium mb-6">
              <Sparkles size={14} />
              Neuro-Symbolic AI · Tiếng Việt Native
            </span>
          </motion.div>

          {/* Tiêu đề */}
          <motion.h1
            variants={fadeUp}
            transition={{ ...easeOut, delay: 0.05 }}
            className="text-5xl sm:text-6xl md:text-7xl font-black text-slate-100 leading-tight mb-6"
          >
            Họp chỉ khi{" "}
            <span className="gradient-text">thực sự</span>
            <br />
            sẵn sàng
          </motion.h1>

          {/* Mô tả */}
          <motion.p
            variants={fadeUp}
            transition={{ ...easeOut, delay: 0.1 }}
            className="text-xl text-slate-400 max-w-2xl mx-auto mb-10 leading-relaxed"
          >
            MeetWise dùng AI để tự động kiểm tra xem cuộc họp của bạn đã đủ điều kiện chưa —
            trước khi nó diễn ra. Tiết kiệm hàng giờ cho cả đội mỗi tuần.
          </motion.p>

          {/* CTA */}
          <motion.div
            variants={fadeUp}
            transition={{ ...easeOut, delay: 0.15 }}
            className="flex flex-col sm:flex-row items-center justify-center gap-4"
          >
            <Link
              href="/dang-ky"
              className="btn-primary text-base py-3 px-8 flex items-center gap-2 group"
            >
              Bắt đầu miễn phí
              <ArrowRight size={18} className="group-hover:translate-x-1 transition-transform" />
            </Link>
            <Link href="/dang-nhap" className="btn-secondary text-base py-3 px-8">
              Đăng nhập →
            </Link>
          </motion.div>

          <motion.p
            variants={fadeIn}
            transition={{ ...easeOut, delay: 0.25 }}
            className="text-sm text-slate-600 mt-4"
          >
            Không cần thẻ tín dụng · Miễn phí mãi mãi cho cá nhân
          </motion.p>
        </motion.div>

        {/* === Demo card === */}
        <motion.div
          variants={scaleIn}
          initial="initial"
          animate="animate"
          transition={{ ...easeOut, delay: 0.3 }}
          className="mt-16 max-w-lg mx-auto"
        >
          <div className="glass rounded-2xl p-6 text-left border border-white/[0.08] shadow-2xl shadow-black/40">
            <div className="flex items-center gap-2 text-xs text-slate-500 mb-4">
              <div className="w-2 h-2 rounded-full bg-green-400 animate-pulse" />
              Ví dụ thực tế — đánh giá trong 47ms
            </div>
            <div className="space-y-3">
              <div>
                <p className="text-xs text-slate-500 mb-1">Điều kiện cuộc họp:</p>
                <code className="text-sm text-violet-300 font-mono">
                  Slide cập nhật hoặc Sheet chốt số, bắt buộc Manager rảnh
                </code>
              </div>
              <div className="border-t border-white/[0.06] pt-3 space-y-2">
                <p className="text-xs text-slate-500">Trạng thái thực tế:</p>
                <div className="flex flex-wrap gap-2">
                  {[
                    { name: "Slide_Done", val: false },
                    { name: "Sheet_Done", val: true },
                    { name: "Manager_Free", val: false },
                  ].map((f) => (
                    <span
                      key={f.name}
                      className={`badge text-xs ${f.val ? "text-green-400 bg-green-400/10 border-green-400/20" : "text-red-400 bg-red-400/10 border-red-400/20"}`}
                    >
                      {f.val ? <CheckCircle2 size={11} /> : <XCircle size={11} />}
                      {f.name}
                    </span>
                  ))}
                </div>
              </div>
              <motion.div
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.8, duration: 0.4 }}
                className="border-t border-white/[0.06] pt-3 flex items-center gap-3"
              >
                <div className="w-10 h-10 rounded-xl bg-red-500/20 flex items-center justify-center">
                  <XCircle size={20} className="text-red-400" />
                </div>
                <div>
                  <p className="text-red-400 font-bold">🔴 Cần dời lịch</p>
                  <p className="text-xs text-slate-400">Manager_Free chưa thỏa mãn</p>
                </div>
              </motion.div>
            </div>
          </div>
        </motion.div>
      </section>

      {/* === Cách hoạt động === */}
      <section className="py-24 px-6">
        <div className="max-w-4xl mx-auto">
          <motion.div
            initial="initial"
            whileInView="animate"
            viewport={{ once: true, margin: "-100px" }}
            variants={stagger}
            className="text-center mb-16"
          >
            <motion.p variants={fadeUp} transition={easeOutFast} className="text-violet-400 text-sm font-medium uppercase tracking-widest mb-3">
              Đơn giản chỉ 3 bước
            </motion.p>
            <motion.h2 variants={fadeUp} transition={easeOutFast} className="text-3xl sm:text-4xl font-bold text-slate-100">
              Cách MeetWise hoạt động
            </motion.h2>
          </motion.div>

          <motion.div
            initial="initial"
            whileInView="animate"
            viewport={{ once: true, margin: "-80px" }}
            variants={staggerFast}
            className="grid md:grid-cols-3 gap-6"
          >
            {howItWorks.map((item, i) => (
              <motion.div
                key={item.step}
                variants={fadeUp}
                transition={{ ...easeOut, delay: i * 0.1 }}
                className="glass rounded-2xl p-6 relative overflow-hidden group hover:border-violet-500/30 transition-colors"
              >
                <div className="text-6xl font-black text-white/[0.04] absolute top-3 right-4 select-none">
                  {item.step}
                </div>
                <div className="w-10 h-10 rounded-xl bg-violet-500/10 border border-violet-500/20 flex items-center justify-center mb-4">
                  <span className="text-violet-400 font-bold text-sm">{item.step}</span>
                </div>
                <h3 className="text-slate-100 font-semibold mb-2">{item.title}</h3>
                <p className="text-slate-400 text-sm leading-relaxed">{item.desc}</p>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* === Tính năng === */}
      <section className="py-24 px-6">
        <div className="max-w-5xl mx-auto">
          <motion.div
            initial="initial"
            whileInView="animate"
            viewport={{ once: true, margin: "-100px" }}
            variants={stagger}
            className="text-center mb-16"
          >
            <motion.p variants={fadeUp} transition={easeOutFast} className="text-violet-400 text-sm font-medium uppercase tracking-widest mb-3">
              Tính năng nổi bật
            </motion.p>
            <motion.h2 variants={fadeUp} transition={easeOutFast} className="text-3xl sm:text-4xl font-bold text-slate-100">
              Mọi thứ bạn cần để họp hiệu quả
            </motion.h2>
          </motion.div>

          <motion.div
            initial="initial"
            whileInView="animate"
            viewport={{ once: true, margin: "-80px" }}
            variants={staggerFast}
            className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5"
          >
            {features.map((f, i) => (
              <motion.div
                key={f.title}
                variants={scaleIn}
                transition={{ ...easeOut, delay: i * 0.07 }}
                whileHover={{ y: -4, transition: { duration: 0.2 } }}
                className="glass rounded-2xl p-6 cursor-default"
              >
                <div className={`w-11 h-11 rounded-xl border flex items-center justify-center mb-4 ${f.bg}`}>
                  <f.icon size={22} className={f.color} />
                </div>
                <h3 className="text-slate-100 font-semibold mb-2">{f.title}</h3>
                <p className="text-slate-400 text-sm leading-relaxed">{f.desc}</p>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* === CTA cuối === */}
      <section className="py-24 px-6">
        <motion.div
          initial="initial"
          whileInView="animate"
          viewport={{ once: true, margin: "-80px" }}
          variants={stagger}
          className="max-w-2xl mx-auto text-center"
        >
          <motion.div
            variants={scaleIn}
            transition={easeOut}
            className="glass rounded-3xl p-12 border border-violet-500/20 relative overflow-hidden"
          >
            {/* Glow nền */}
            <div className="absolute inset-0 bg-gradient-to-br from-violet-500/10 to-blue-500/5 pointer-events-none" />

            <motion.div variants={fadeUp} transition={easeOutFast}>
              <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-violet-500 to-violet-700 flex items-center justify-center mx-auto mb-6 shadow-xl shadow-violet-500/30">
                <Zap size={28} className="text-white" />
              </div>
            </motion.div>

            <motion.h2 variants={fadeUp} transition={{ ...easeOutFast, delay: 0.05 }} className="text-3xl font-bold text-slate-100 mb-4">
              Sẵn sàng họp thông minh hơn?
            </motion.h2>
            <motion.p variants={fadeUp} transition={{ ...easeOutFast, delay: 0.1 }} className="text-slate-400 mb-8">
              Tham gia miễn phí, không cần thẻ tín dụng. Bắt đầu đánh giá cuộc họp đầu tiên trong vòng 2 phút.
            </motion.p>
            <motion.div variants={fadeUp} transition={{ ...easeOutFast, delay: 0.15 }} className="flex flex-col sm:flex-row gap-3 justify-center">
              <Link href="/dang-ky" className="btn-primary text-base py-3 px-8 flex items-center justify-center gap-2 group">
                Bắt đầu miễn phí
                <ArrowRight size={18} className="group-hover:translate-x-1 transition-transform" />
              </Link>
              <Link href="/dang-nhap" className="btn-secondary text-base py-3 px-8">
                Đã có tài khoản
              </Link>
            </motion.div>
          </motion.div>
        </motion.div>
      </section>

      {/* === Footer === */}
      <motion.footer
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6 }}
        className="border-t border-white/[0.06] py-8 px-6 text-center"
      >
        <div className="flex items-center justify-center gap-2 mb-3">
          <div className="w-6 h-6 rounded-lg bg-gradient-to-br from-violet-500 to-violet-700 flex items-center justify-center">
            <Zap size={12} className="text-white" />
          </div>
          <span className="font-bold gradient-text">MeetWise</span>
        </div>
        <p className="text-slate-600 text-sm">
          Xây dựng bởi{" "}
          <span className="text-violet-500">Đoàn Hoàng Việt (Việt Gamer)</span>
          {" "}· Powered by FastAPI · LangGraph · Z3 · Next.js · Supabase
        </p>
      </motion.footer>
    </div>
  );
}
