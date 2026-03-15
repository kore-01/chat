# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenClaw Chat Gateway is a production-grade Web client for OpenClaw ecosystem. It provides multi-agent sandbox management with fully isolated workspaces and memory for each agent.

## Commands

```bash
# Development (runs both frontend and backend concurrently)
npm run dev

# Build both frontend and backend
npm run build

# Production build and start
npm run release

# Frontend only
cd frontend && npm run dev

# Backend only
cd backend && npm run dev
```

## Architecture

### Backend (Express + TypeScript)

- **`backend/src/index.ts`** - Main server with all REST API routes and WebSocket handling
- **`backend/src/db.ts`** - SQLite database operations using better-sqlite3
- **`backend/src/session-manager.ts`** - Session lifecycle management
- **`backend/src/agent-provisioner.ts`** - Agent sandbox provisioning: creates isolated workspaces with SOUL.md, USER.md, AGENTS.md, TOOLS.md, HEARTBEAT.md, IDENTITY.md in `~/.openclaw/workspace-{agentId}`
- **`backend/src/openclaw-client.ts`** - WebSocket client connecting to OpenClaw Gateway
- **`backend/src/config-manager.ts`** - Configuration persistence

### Frontend (React + Vite + TypeScript + Tailwind CSS v4)

- **`frontend/src/App.tsx`** - Main app with hash-based routing, auth state, session management
- **`frontend/src/components/ChatView.tsx`** - Chat interface with SSE streaming
- **`frontend/src/components/Sidebar.tsx`** - Session list and navigation
- **`frontend/src/components/SettingsView.tsx`** - Gateway, models, commands, about tabs

### Key Patterns

1. **Agent Sandboxing**: Each agent has isolated workspace under `~/.openclaw/workspace-{agentId}/` with independent configuration files
2. **SSE Streaming**: Chat uses Server-Sent Events for real-time AI responses (`/api/chat`)
3. **File Preview**: LibreOffice integration for Word/PPT/Excel → PDF conversion (fallback to client-side rendering)
4. **WebSocket**: Long-lived connections to OpenClaw Gateway via `OpenClawClient`
