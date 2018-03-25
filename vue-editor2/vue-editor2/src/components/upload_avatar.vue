<template>
    
  <div class="avata-upload">
    <div v-if="!image">
      <div tabindex="0" class="jx-avatar-upload">
        <i aria-hidden="true" class="material-icons icon avatar-icon">photo_camera</i>
        <small class="jx-avatar-title"> Ảnh đại diện </small>
        <input type="file" :name="name" class="jx-avatar-upload__input" @change="onFileChange">
      </div>
    </div>
    <div v-else>
      <div tabindex="0" class="jx-avatar-img-wrap">
        <img :src="image" class="jx-avatar-img" />
        <span class="el-upload-list__item-actions">
          <span class="el-upload-list__item-preview">
            <input type="file" :name="name" class="jx-avatar-upload__input_left" @change="onFileChange">
            <i aria-hidden="true" class="material-icons icon avatar-change" >photo_camera</i>
          </span>
          <span class="el-upload-list__item-delete">
            <i aria-hidden="true" class="material-icons icon avatar-remove" @click="removeAvatar" >clear</i>
          </span>
        </span>
      </div>
    </div>
  </div>

</template>

<script>
  import axios from 'axios'

  const COMPONENT_NAME = 'jx-avata-upload'
  
  export default {
    name: COMPONENT_NAME,
    props: {
      name: String,
      image: null,
      imageinit: null,
      filename: String,
      uploadapi: null,
      deleteapi: null,
      snackbar: false,
      snackbarerror: false,
      pk: null,
      groupid: null
    },
    data () {
      return {
        image: '',
        uploadapi: '',
        deleteapi: '',
        pk: 0,
        groupid: 0
      }
    },
    methods: {
      onFileChange (e) {
        var vm = this
        var files = e.target.files || e.dataTransfer.files
        if (files) {
          if (files.length > 0) {
            vm.filename = [...files].map(file => file.name).join(', ')
          } else {
            vm.filename = null
          }
        } else {
          vm.filename = e.target.value.split('\\').pop()
        }
        if (vm.uploadapi.length > 0) {
          const config = {
            headers: { 'content-type': 'multipart/form-data', 'groupId': vm.groupid }
          }
          var avataDataJSON = {
            name: files[0].name,
            size: files[0].size,
            file: files[0]
          }
          vm.createImage(files[0])
          axios.post(vm.uploadapi, avataDataJSON, config).then(function (response) {
            console.log(response)
            var avatasnack = {
              snackbar: true,
              snackbarerror: false,
              image: vm.image
            }
            vm.$emit('show-snackbar-detail', avatasnack)
          })
          .catch(function (error) {
            console.log(error)
            var avatasnack = {
              snackbar: false,
              snackbarerror: true,
              image: vm.imageinit
            }
            vm.$emit('show-snackbar-detail', avatasnack)
          })
        }
      },
      createImage (file) {
        var reader = new FileReader()
        var vm = this
        reader.onload = (e) => {
          vm.image = e.target.result
        }
        reader.readAsDataURL(file)
      },
      removeAvatar () {
        var vm = this
        vm.$dialog.confirm('Bạn có muôn xoá ảnh này khỏi ảnh đại diện?.', {
          loader: true,
          okText: 'Đồng ý',
          cancelText: 'Quay lại',
          animation: 'fade'
        })
        .then((dialog) => {
          if (vm.deleteapi.length > 0) {
            const config = {
              headers: { 'groupId': vm.groupid }
            }
            console.log(vm.deleteapi + '/' + vm.pk)
            axios.delete(vm.deleteapi + '/' + vm.pk, { }, config).then(function (response) {
              console.log('---> response delete ')
              var avatasnack = {
                snackbar: true,
                snackbarerror: false,
                image: ''
              }
              vm.$emit('show-snackbar-detail', avatasnack)
              dialog.close()
            })
            .catch(function (error) {
              console.log(error)
              var avatasnack = {
                snackbar: false,
                snackbarerror: true,
                image: vm.imageinit
              }
              vm.$emit('show-snackbar-detail', avatasnack)
            })
          }
        })
        .catch(() => {
          console.log('Delete aborted')
        })
      }
    }
  }
</script>
