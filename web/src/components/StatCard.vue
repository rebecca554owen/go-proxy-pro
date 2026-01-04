<!--
 * 文件作用：统一统计卡片组件，响应式栅格布局
 * 负责功能：
 *   - 响应式栅格布局（xs/sm/md/lg）
 *   - 统一卡片样式
 *   - 可配置图标、渐变色
 * 重要程度：⭐⭐⭐⭐ 重要（响应式核心组件）
 * 依赖模块：element-plus
-->
<template>
  <el-col :xs="24" :sm="12" :md="cols" :lg="cols">
    <el-card shadow="hover" class="stat-card">
      <div class="stat-content">
        <div class="stat-icon" :style="{ background: gradient }">
          <i :class="icon"></i>
        </div>
        <div class="stat-info">
          <h3>{{ title }}</h3>
          <p class="stat-value">{{ value }}</p>
          <p v-if="subtitle" class="stat-subtitle">{{ subtitle }}</p>
        </div>
      </div>
      <slot />
    </el-card>
  </el-col>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true
  },
  value: {
    type: [String, Number],
    required: true
  },
  subtitle: String,
  icon: {
    type: String,
    default: 'fa-solid fa-chart-line'
  },
  gradient: {
    type: String,
    default: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
  },
  cols: {
    type: Number,
    default: 6
  }
})
</script>

<style scoped>
.stat-card {
  height: 100%;
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 22px;
  flex-shrink: 0;
}

.stat-info {
  flex: 1;
}

.stat-info h3 {
  margin: 0 0 8px;
  font-size: 14px;
  font-weight: 500;
  color: #606266;
}

.stat-value {
  margin: 0 0 4px;
  font-size: 24px;
  font-weight: 600;
  color: #303133;
}

.stat-subtitle {
  margin: 0;
  font-size: 12px;
  color: #909399;
}

@media (max-width: 768px) {
  .stat-icon {
    width: 44px;
    height: 44px;
    font-size: 18px;
  }

  .stat-value {
    font-size: 20px;
  }
}
</style>
