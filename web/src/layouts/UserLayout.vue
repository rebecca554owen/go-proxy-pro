<!--
 * 文件作用：用户中心布局组件
 * 负责功能：
 *   - 用户中心页面框架
 *   - 顶部导航栏
 *   - 侧边菜单
 *   - 内容区域
 *   - 移动端抽屉式菜单
 * 重要程度：⭐⭐⭐⭐⭐ 核心（用户界面框架 + 响应式）
-->
<template>
  <el-container class="user-layout">
    <!-- 移动端遮罩 -->
    <div
      v-if="isMobile && sidebarVisible"
      class="sidebar-overlay"
      @click="sidebarVisible = false"
    ></div>

    <!-- 顶部导航 -->
    <el-header class="header">
      <div class="header-left">
        <!-- 移动端菜单按钮 -->
        <el-icon v-if="isMobile" class="menu-btn" @click="sidebarVisible = !sidebarVisible">
          <Menu />
        </el-icon>
        <div class="logo">
          <el-icon :size="24"><Monitor /></el-icon>
          <span class="logo-text">AiProxy 用户中心</span>
        </div>
      </div>
      <div class="header-right">
        <el-dropdown @command="handleCommand">
          <span class="user-info">
            <el-avatar :size="32" class="avatar">
              {{ userStore.user?.username?.charAt(0)?.toUpperCase() || 'U' }}
            </el-avatar>
            <span class="username">{{ userStore.user?.username || '用户' }}</span>
            <el-icon><ArrowDown /></el-icon>
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="profile">
                <el-icon><User /></el-icon> 个人资料
              </el-dropdown-item>
              <el-dropdown-item v-if="userStore.user?.role === 'admin'" command="admin" divided>
                <el-icon><Setting /></el-icon> 管理后台
              </el-dropdown-item>
              <el-dropdown-item command="logout" divided>
                <el-icon><SwitchButton /></el-icon> 退出登录
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-header>

    <el-container class="main-container">
      <!-- 侧边菜单 -->
      <el-aside
        :width="isMobile ? '200px' : (isCollapse ? '64px' : '200px')"
        :class="{ 'aside': true, 'mobile-visible': sidebarVisible }"
      >
        <el-menu
          :default-active="activeMenu"
          :collapse="isCollapse"
          :router="true"
          class="side-menu"
        >
          <el-menu-item index="/user/dashboard" @mouseenter="prefetchFor('/user/dashboard')">
            <el-icon><DataAnalysis /></el-icon>
            <template #title>仪表盘</template>
          </el-menu-item>
          <el-menu-item index="/user/api-keys" @mouseenter="prefetchFor('/user/api-keys')">
            <el-icon><Key /></el-icon>
            <template #title>我的 API Key</template>
          </el-menu-item>
          <el-menu-item index="/user/packages" @mouseenter="prefetchFor('/user/packages')">
            <el-icon><Box /></el-icon>
            <template #title>我的套餐</template>
          </el-menu-item>
          <el-menu-item index="/user/records" @mouseenter="prefetchFor('/user/records')">
            <el-icon><Document /></el-icon>
            <template #title>使用记录</template>
          </el-menu-item>
        </el-menu>

        <div v-if="!isMobile" class="collapse-btn" @click="isCollapse = !isCollapse">
          <el-icon v-if="isCollapse"><Expand /></el-icon>
          <el-icon v-else><Fold /></el-icon>
        </div>
      </el-aside>

      <!-- 主内容区 -->
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { prefetchChunk } from '@/prefetch'
import {
  Monitor, ArrowDown, User, Setting, SwitchButton,
  DataAnalysis, Key, Box, Document, Expand, Fold, Menu
} from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const isCollapse = ref(false)
const isMobile = ref(false)
const sidebarVisible = ref(false)

// 移动端检测
function checkMobile() {
  isMobile.value = window.innerWidth < 768
  if (!isMobile.value) {
    sidebarVisible.value = false
  }
}

onMounted(() => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
})

onUnmounted(() => {
  window.removeEventListener('resize', checkMobile)
})

const activeMenu = computed(() => route.path)

function prefetchFor(path) {
  const loaders = {
    '/user/dashboard': () => import('@/views/user/UserDashboard.vue'),
    '/user/api-keys': () => import('@/views/user/MyAPIKeys.vue'),
    '/user/packages': () => import('@/views/user/MyPackages.vue'),
    '/user/records': () => import('@/views/user/MyUsageRecords.vue'),
    '/user/profile': () => import('@/views/Profile.vue'),
    '/admin/system-monitor': () => import('@/views/SystemMonitor.vue')
  }
  const loader = loaders[path]
  if (!loader) return
  prefetchChunk(path, loader)
}

const handleCommand = (command) => {
  switch (command) {
    case 'profile':
      prefetchFor('/user/profile')
      router.push('/user/profile')
      break
    case 'admin':
      prefetchFor('/admin/system-monitor')
      router.push('/admin/system-monitor')
      break
    case 'logout':
      userStore.logout()
      router.push('/login')
      break
  }
}
</script>

<style scoped>
.user-layout {
  height: 100vh;
  background: #f5f7fa;
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

/* 移动端菜单按钮 */
@media (max-width: 768px) {
  .menu-btn {
    font-size: 24px;
    cursor: pointer;
    margin-right: 12px;
    color: white;
  }
}

/* 移动端侧边栏抽屉模式 */
@media (max-width: 768px) {
  .aside {
    position: fixed !important;
    z-index: 2000;
    height: calc(100vh - 60px);
    top: 60px;
    transform: translateX(-100%);
    transition: transform 0.3s;
  }

  .aside.mobile-visible {
    transform: translateX(0);
  }

  .sidebar-overlay {
    position: fixed;
    top: 60px;
    left: 0;
    width: 100vw;
    height: calc(100vh - 60px);
    background: rgba(0, 0, 0, 0.5);
    z-index: 1999;
  }

  .logo-text {
    font-size: 14px;
  }

  .username {
    display: none;
  }
}

.header-left {
  display: flex;
  align-items: center;
}

.logo {
  display: flex;
  align-items: center;
  color: white;
  font-size: 18px;
  font-weight: bold;
}

.logo-text {
  margin-left: 10px;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  color: white;
  cursor: pointer;
  padding: 8px 12px;
  border-radius: 8px;
  transition: background 0.3s;
}

.user-info:hover {
  background: rgba(255, 255, 255, 0.1);
}

.avatar {
  background: rgba(255, 255, 255, 0.3);
  color: white;
  font-weight: bold;
}

.username {
  margin: 0 8px;
  font-size: 14px;
}

.main-container {
  height: calc(100vh - 60px);
}

.aside {
  background: white;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  transition: width 0.3s;
}

.side-menu {
  flex: 1;
  border-right: none;
}

.side-menu:not(.el-menu--collapse) {
  width: 200px;
}

.collapse-btn {
  padding: 15px;
  text-align: center;
  cursor: pointer;
  border-top: 1px solid #eee;
  color: #909399;
  transition: all 0.3s;
}

.collapse-btn:hover {
  background: #f5f7fa;
  color: #409eff;
}

.main {
  padding: 20px;
  background: #f5f7fa;
  overflow-y: auto;
}
</style>
