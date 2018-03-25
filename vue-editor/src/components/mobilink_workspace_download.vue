<template>
  <div class="workspaces--download--mobilink">
    
    <div v-if="is_download != 'true'">
      <v-chip outline v-for="(item, index) in items" v-bind:key="index" v-model="item.selected" :style="'color:' + item.color">
        {{item.text}} {{item.selected}}
      </v-chip>
    </div>
    
    <ul class="workspaces__download_links" v-else>
      <li v-for="(item, index) in itemsLinks" v-bind:key="index" class="py-0 px-0">
        <div class="layout wrap">
          <div class="flex xs12">
            <v-btn flat v-on:click.native="downloadFileAttachListItem(item)" class="mx-0 my-0">
              <v-icon>file_download</v-icon>
              Download
            </v-btn>
          </div>
        </div>
      </li>
    </ul>

  </div>
</template>

<script>
import axios from 'axios'
const COMPONENT_NAME = 'jx-mobilink-workspace-download'

export default {
  name: COMPONENT_NAME,
  props: {
    class_pk: null,
    class_name: null,
    group_id: null,
    workspace_api: '',
    files_api: '',
    item_text: '',
    item_value: '',
    file_text: '',
    file_value: '',
    is_download: 'false'
  },
  data () {
    return {
      date: null,
      dateFormatted: null,
      menu: false,
      mobilinkStatus: {},
      statusEdit: false,
      snackbarStatus: false,
      snackbarerorStatus: false,
      items: [],
      itemsLinks: []
    }
  },
  created () {
    var vm = this
    const config = {
      headers: {
        'groupId': vm.group_id,
        'Accept': 'application/json'
      }
    }
    vm.$nextTick(function () {
      if (vm.is_download == 'true') {
        axios.get(vm.files_api + '/' + vm.class_name  + '/' + vm.class_pk, config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            for (var key in serializable.data) {
              vm.itemsLinks.push(
                {
                  'id': serializable.data[key][vm.file_value],
                  'text': serializable.data[key][vm.file_text]
                }
              )
            }
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      } else {
        axios.get(vm.workspace_api + '/' + vm.class_name  + '/' + vm.class_pk, config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            for (var key in serializable.data) {
              vm.items.push(
                {
                  'id': serializable.data[key][vm.item_value],
                  'text': serializable.data[key][vm.item_text],
                  'selected': true
                }
              )
            }
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      }
    })
  },
  methods: {
    downloadFileAttachListItem: function (item) {
      console.log(item)
    }
  }
}
</script>

<style>
  .workspaces__download_links .btn__content{
    padding: 0;
  }
  .workspaces__download_links button.btn{
    padding: 0;
    height: 25px;
    font-size: 11px;
  }
</style>
