<template>
  <div :id="'album_image_'+id" style="width: 100%;">
    
    <uploader :options="options" class="uploader-example" v-if="albumProcessing">
      <uploader-unsupport></uploader-unsupport>
      <jx-mobilink-album-image
        :id="id"
        :class_name="class_name"
        :class_pk="class_pk"
        :group_id="group_id"
        auto="true"
        :album_api="album_api"
      ></jx-mobilink-album-image>
    </uploader>
    <jx-mobilink-album-image v-else
        :id="id"
        :class_name="class_name"
        :class_pk="class_pk"
        :group_id="group_id"
        :album_api="album_api"
        @init-album-file-upload="initAlbumFileUpload"
      ></jx-mobilink-album-image>
  </div>
</template>

<script>
import AlbumFileSRC from './mobilink_album_image.vue'
const COMPONENT_NAME = 'jx-mobilink-album-image-use'

export default {
  name: COMPONENT_NAME,
  props: {
    id: null,
    class_pk: null,
    class_name: null,
    group_id: null,
    album_api: '',
    options: null
  },
  data () {
    return {
      albumProcessing: false
    }
  },
  components: {
    AlbumFileSRC
  },
  methods: {
    initAlbumFileUpload: function (prevewConfig) {
      this.albumProcessing = true
      this.$emit('init-album-file-upload', prevewConfig)
    }
  }
}
</script>

<style>

</style>
