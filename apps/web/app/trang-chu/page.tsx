import type { Metadata } from "next";
import LandingClient from "./LandingClient";

export const metadata: Metadata = {
  title: "MeetWise — Họp chỉ khi thực sự sẵn sàng",
  description:
    "Nền tảng AI giúp doanh nghiệp đánh giá mức độ sẵn sàng cuộc họp. Tránh họp vô bổ, tiết kiệm thời gian của cả đội.",
};

export default function LandingPage() {
  return <LandingClient />;
}
