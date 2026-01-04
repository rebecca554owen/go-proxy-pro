<!--
 * 文件作用：响应式弹窗组件，移动端自动适配宽度
 * 负责功能：
 *   - 桌面端：90% 宽度，最大 800px
 *   - 移动端：95% 宽度，接近全屏
 *   - 自动检测屏幕尺寸
 * 重要程度：⭐⭐⭐⭐ 重要（响应式核心组件）
 * 依赖模块：element-plus
-->
<template>
  <el-dialog
    v-model="visible"
    :width="dialogWidth"
    :class="{ 'responsive-dialog': true }"
    v-bind="$attrs"
  >
    <slot />
  </el-dialog>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  width: {
    type: String,
    default: '90%'
  },
  maxWidth: {
    type: String,
    default: '800px'
  }
})

const emit = defineEmits(['update:modelValue'])

const isMobile = ref(false)

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const dialogWidth = computed(() => {
  if (isMobile.value) {
    return '95%'
  }
  return props.width
})

function checkMobile() {
  isMobile.value = window.innerWidth < 768
}

onMounted(() => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
})

onUnmounted(() => {
  window.removeEventListener('resize', checkMobile)
})
</script>
