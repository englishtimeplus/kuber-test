# 1) 빌드 스테이지
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# 2) 프로덕션 실행 스테이지
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
# 불필요한 파일 제거
RUN apk add --no-cache tini
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# 컨테이너 시작 시 tini를 통해 PID 1 문제 해결
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node_modules/.bin/next", "start", "-p", "3000"]
