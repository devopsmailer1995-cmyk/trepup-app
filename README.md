# Trepup App - Frontend Demo

Next.js 14 Frontend Application deployed to AWS ECS Fargate.

## Features

- ✅ Next.js 14 (Demo)
- ✅ GitHub Actions CI/CD with OIDC
- ✅ Docker containerization
- ✅ ECS Fargate deployment
- ✅ Health check endpoint
- ✅ CDN configuration

## Deployment

Push to `main` branch triggers automatic deployment:

```bash
git add .
git commit -m "Deploy changes"
git push origin main
```

## Configuration

- **Port**: 3000
- **Health Check**: `/api/health`
- **CDN Base**: `https://media.dev.trepup.com`

## Workflow

See `.github/workflows/deploy-frontend.yml` for the complete CI/CD pipeline.

## Repository

https://github.com/devopsmailer1995-cmyk/trepup-app
# Trigger deployment
