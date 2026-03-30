# Demo Next.js Frontend Dockerfile for trepup-app
# This is a simplified demo version for testing the pipeline

FROM node:20-alpine

WORKDIR /app

# Create a simple Next.js-like demo app
RUN echo '{"name":"trepup-app","version":"1.0.0","scripts":{"start":"node server.js"}}' > package.json

# Create a simple server that mimics Next.js standalone
RUN cat > server.js << 'EOF'
const http = require('http');
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  if (req.url === '/api/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'healthy', service: 'trepup-app', timestamp: new Date().toISOString() }));
  } else {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(`
      <!DOCTYPE html>
      <html>
        <head><title>Trepup App - Demo</title></head>
        <body style="font-family: Arial; padding: 50px; text-align: center;">
          <h1>🚀 Trepup App - Frontend Demo</h1>
          <p>Next.js 14 Application</p>
          <p>Deployed to ECS Fargate via GitHub Actions</p>
          <p>CDN Base: ${process.env.NEXT_PUBLIC_MEDIA_CDN_BASE || 'Not Set'}</p>
          <p>Environment: ${process.env.NODE_ENV || 'development'}</p>
          <p>Port: ${port}</p>
          <hr>
          <small>Build: ${new Date().toISOString()}</small>
        </body>
      </html>
    `);
  }
});

server.listen(port, () => {
  console.log('✅ Trepup App listening on port ' + port);
  console.log('📦 CDN Base: ' + (process.env.NEXT_PUBLIC_MEDIA_CDN_BASE || 'Not Set'));
});
EOF

# Build argument for Next.js public env var
ARG NEXT_PUBLIC_MEDIA_CDN_BASE
ENV NEXT_PUBLIC_MEDIA_CDN_BASE=$NEXT_PUBLIC_MEDIA_CDN_BASE
ENV NODE_ENV=production
ENV PORT=3000

# Create non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs && \
    chown -R nextjs:nodejs /app

USER nextjs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

CMD ["node", "server.js"]
