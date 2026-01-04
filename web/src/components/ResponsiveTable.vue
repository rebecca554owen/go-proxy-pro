<!--
 * 文件作用：响应式表格组件，移动端自动切换为卡片视图
 * 负责功能：
 *   - 桌面端：显示标准表格
 *   - 移动端：自动切换为卡片视图
 *   - 响应式断点：768px
 * 重要程度：⭐⭐⭐⭐ 重要（响应式核心组件）
 * 依赖模块：element-plus
-->
<template>
  <div class="responsive-table-wrapper">
    <!-- 桌面端表格 -->
    <el-table
      v-if="!isMobile"
      :data="data"
      v-bind="$attrs"
      class="desktop-table"
    >
      <slot />
    </el-table>

    <!-- 移动端卡片视图 -->
    <div v-else class="mobile-cards">
      <div
        v-for="(row, index) in data"
        :key="row.id || index"
        class="mobile-card"
        @click="handleRowClick(row)"
      >
        <slot name="mobile-card" :row="row" :index="index">
          <!-- 默认卡片模板 -->
          <div v-for="col in columns" :key="col.prop" class="card-item">
            <span class="card-label">{{ col.label }}</span>
            <span class="card-value">{{ getCellValue(row, col) }}</span>
          </div>
        </slot>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const props = defineProps({
  data: {
    type: Array,
    default: () => []
  },
  columns: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['row-click'])

const isMobile = ref(false)

function checkMobile() {
  isMobile.value = window.innerWidth < 768
}

function getCellValue(row, col) {
  const value = row[col.prop]
  return col.formatter ? col.formatter(value, row) : value
}

function handleRowClick(row) {
  emit('row-click', row)
}

onMounted(() => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
})

onUnmounted(() => {
  window.removeEventListener('resize', checkMobile)
})
</script>

<style scoped>
.responsive-table-wrapper {
  width: 100%;
}

.mobile-cards {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.mobile-card {
  background: white;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  cursor: pointer;
  transition: box-shadow 0.3s;
}

.mobile-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.card-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
}

.card-item:last-child {
  border-bottom: none;
}

.card-label {
  font-weight: 500;
  color: #606266;
  flex-shrink: 0;
}

.card-value {
  color: #303133;
  text-align: right;
  word-break: break-word;
  margin-left: 16px;
}
</style>
