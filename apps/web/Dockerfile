# ============================================================
# Dockerfile — MeetWise Frontend (Next.js 14, Multi-stage)
# Tác giả: Đoàn Hoàng Việt (Việt Gamer)
#
# Stage 1 (deps):    Cài npm dependencies
# Stage 2 (builder): Build production bundle Next.js
# Stage 3 (runner):  Image tối giản chỉ chứa output cần thiết
# Kết quả: Image nhỏ ~150MB thay vì ~1GB
# ============================================================

# ─── Stage 1: Cài dependencies ────────────────────────────────
FROM node:20-alpine AS deps

# libc6-compat để tương thích Alpine với một số native modules
RUN apk add --no-cache libc6-compat

WORKDIR /app

# Copy package files trước (tận dụng Docker layer cache)
COPY package.json package-lock.json* ./

# Cài dependencies đúng theo lock file (reproducible build)
RUN npm ci --frozen-lockfile

# ─── Stage 2: Build production bundle ────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependencies từ stage deps
COPY --from=deps /app/node_modules ./node_modules

# Copy toàn bộ source code
COPY . .

# Biến môi trường BUILD TIME (không phải runtime)
# NEXT_PUBLIC_* phải được truyền vào lúc build
ARG NEXT_PUBLIC_API_URL=http://localhost:8000
ARG NEXT_PUBLIC_SUPABASE_URL=https://placeholder.supabase.co
ARG NEXT_PUBLIC_SUPABASE_ANON_KEY=placeholder

ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_SUPABASE_URL=$NEXT_PUBLIC_SUPABASE_URL
ENV NEXT_PUBLIC_SUPABASE_ANON_KEY=$NEXT_PUBLIC_SUPABASE_ANON_KEY

# Tắt telemetry Next.js
ENV NEXT_TELEMETRY_DISABLED=1

# Build production
RUN npm run build

# ─── Stage 3: Runtime tối giản ────────────────────────────────
FROM node:20-alpine AS runner

WORKDIR /app

# Môi trường production
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000

# Non-root user để bảo mật
RUN addgroup --system --gid 1001 nodejs && \
    adduser  --system --uid 1001 nextjs

# Chỉ copy những gì cần thiết để chạy (standalone output)
COPY --from=builder /app/public ./public

# Cấp quyền cho nextjs user trước khi copy
RUN mkdir .next && chown nextjs:nodejs .next

# Standalone output của Next.js (tối ưu dung lượng)
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
    CMD wget -qO- http://localhost:3000/ || exit 1

# Chạy standalone server Next.js
CMD ["node", "server.js"]
