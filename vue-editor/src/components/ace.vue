<template>
    <div :id="editorId" style="width: 100%; height: 100%;"></div>
</template>

<script>
  const COMPONENT_NAME = 'jx-ace'
  
  export default {
    name: COMPONENT_NAME,
    props: ['editorId', 'content', 'lang', 'theme'],
    data () {
      return {
        editor: Object,
        beforeContent: ''
      }
    },
    watch: {
      'content': function (value) {
        if (this.beforeContent !== value) {
          this.editor.setValue(value, 1)
        }
      }
    },
    mounted () {
      this.editor = window.ace.edit(this.editorId)
      this.editor.setValue(this.content, 1)
      // mode-xxx.js or theme-xxx.jsがある場合のみ有効
      this.editor.getSession().setMode('ace/mode/text')
      this.editor.setTheme('ace/theme/github')

      this.editor.on('change', () => {
        this.beforeContent = this.editor.getValue()
        this.$emit('change-content', this.editor.getValue())
      })
    }
  }
</script>
