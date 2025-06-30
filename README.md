# kuber-test

This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/basic-features/font-optimization) to automatically optimize and load Inter, a custom Google Font.

## Docker Support

This project includes comprehensive Docker support for both development and production environments.

### Quick Start with Docker

#### Production Build
```bash
# Build production image
npm run docker:build

# Run production container
npm run docker:run
```

#### Development Build
```bash
# Build development image
npm run docker:build-dev

# Run development container
npm run docker:run-dev
```

### Using Docker Compose

#### Production
```bash
# Start production services
npm run docker:compose
```

#### Development
```bash
# Start development services
npm run docker:compose-dev
```

#### Stop Services
```bash
# Stop all services
npm run docker:compose-down
```

### Using Scripts

#### Linux/macOS
```bash
# Make script executable
chmod +x scripts/docker.sh

# Build and run production
./scripts/docker.sh build
./scripts/docker.sh run

# Build and run development
./scripts/docker.sh build-dev
./scripts/docker.sh run-dev

# Stop containers
./scripts/docker.sh stop

# Clean up everything
./scripts/docker.sh clean

# View logs
./scripts/docker.sh logs

# Open shell in container
./scripts/docker.sh shell
```

#### Windows
```cmd
# Build and run production
scripts\docker.bat build
scripts\docker.bat run

# Build and run development
scripts\docker.bat build-dev
scripts\docker.bat run-dev

# Stop containers
scripts\docker.bat stop

# Clean up everything
scripts\docker.bat clean

# View logs
scripts\docker.bat logs

# Open shell in container
scripts\docker.bat shell
```

### Docker Commands

#### Production
- **Build**: `docker build -t kuber-test:latest .`
- **Run**: `docker run -d --name kuber-test-prod -p 3000:3000 kuber-test:latest`
- **Access**: http://localhost:3000

#### Development
- **Build**: `docker build -f Dockerfile.dev -t kuber-test:dev .`
- **Run**: `docker run -d --name kuber-test-dev -p 3001:3000 -v $(pwd):/app -v /app/node_modules kuber-test:dev`
- **Access**: http://localhost:3001

### Docker Compose Services

- **Production**: Runs on port 3000 with optimized build
- **Development**: Runs on port 3001 with hot reloading

### Environment Variables

The following environment variables can be configured:

- `NODE_ENV`: Set to `production` or `development`
- `NEXT_TELEMETRY_DISABLED`: Set to `1` to disable Next.js telemetry
- `PORT`: Application port (default: 3000)
- `HOSTNAME`: Host binding (default: "0.0.0.0")

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.
