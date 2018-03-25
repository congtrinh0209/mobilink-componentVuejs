<template>
  <div class="labels--mobilink">
    
    <v-chip v-if="permission === 'write' || permission === 'owner'" outline close v-for="(item, index) in selectedItems" v-bind:key="index" v-model="item.selected" @input="showDataChange(item, index)" class="mt-0" :style="'color:' + item.color">
      {{item.text}}
    </v-chip>
    <v-chip v-else outline v-for="(item, index) in selectedItems" v-bind:key="index" v-model="item.selected" class="mt-0" :style="'color:' + item.color">
      {{item.text}}
    </v-chip>
    <i v-if="items.length <= 0" class="text-gray">Chưa có</i>
    <v-menu
      offset-x
      :close-on-content-click="false"
      :nudge-width="200"
      v-model="menu"
    >
      <v-btn flat icon slot="activator" class="my-0" v-if="permission === 'write' || permission === 'owner'">
        <v-icon>add_circle</v-icon>
      </v-btn>
      <v-card>
        <v-list class="pb-0 labels__title">
          <v-list-tile>
            <v-list-tile-action>
              <v-switch v-model="addLabel" color="primary" label="Tạo thẻ nhãn mới"></v-switch>
            </v-list-tile-action>
          </v-list-tile>
        </v-list>
        <v-divider></v-divider>
        <v-card v-if="!addLabel" class="no-shadow labels__picker">
          <v-card-title class="pt-0">
            <v-text-field
              append-icon="search"
              label="Search"
              single-line
              hide-details
              v-model="search"
            ></v-text-field>
          </v-card-title>
          <v-data-table
              v-bind:headers="headers"
              v-bind:items="unselectedItems"
              v-bind:search="search"
              v-model="selected"
              item-key="text"
              hide-headers
              hide-actions
            >
            <template slot="items" slot-scope="props">
              <td>
                <v-checkbox
                  primary
                  hide-details
                  v-model="props.selected"
                ></v-checkbox>
              </td>
              <td class="text-xs-left">{{ props.item.text }}</td>

            </template>
          </v-data-table>
        </v-card>
        <v-layout wrap class="px-3" v-else>
          <v-flex xs12 sm3 class="pt-1">
            Tên thẻ nhãn:
          </v-flex>
          <v-flex xs12 sm9>
            <v-text-field
                v-model="labelName"
                placeholder="nhập tên thẻ nhẫn ..."
                class="pt-0"
              ></v-text-field>
          </v-flex>
          <v-flex xs12 sm3 class="pt-2">
            Phạm vi:
          </v-flex>
          <v-flex xs12 sm9 class="no-padding-select">
            <v-select
              v-bind:items="scopes"
              v-model="scope"
              label="Select"
              single-line
              bottom
              item-text="text"
              item-value="value"
              return-object
            ></v-select>
          </v-flex>
          <v-flex xs12 sm3 class="pt-1">
            Màu sắc:
          </v-flex>
          <v-flex xs12 sm9>
            <jx-mobilink-color v-model="color"></jx-mobilink-color>
          </v-flex>
        </v-layout>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn flat @click="menu = false">Cancel</v-btn>
          <v-btn color="primary" flat v-on:click.native="submitLabelsData()">Save</v-btn>
        </v-card-actions>
      </v-card>
    </v-menu>

  </div>
</template>

<script>
import axios from 'axios'
const COMPONENT_NAME = 'jx-mobilink-label'

export default {
  name: COMPONENT_NAME,
  props: {
    class_pk: null,
    class_name: null,
    group_id: null,
    label_api: '',
    item_text: '',
    item_value: '',
    permission: 'read'
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
      selectedItems: [],
      unselectedItems: [],
      selected: [],
      items: [],
      fav: true,
      menu: false,
      addLabel: false,
      hints: true,
      scopes: [
        {
          'value': '',
          'text': 'Tất cả'
        },
        {
          'value': 'activity',
          'text': 'Hoạt động'
        },
        {
          'value': 'document',
          'text': 'Hồ sơ'
        }
      ],
      labelName: '',
      scope: {
        'value': '',
        'text': 'Tất cả'
      },
      color: {
        hex: '#194d33',
        hsl: {
          h: 150,
          s: 0.5,
          l: 0.2,
          a: 1
        },
        hsv: {
          h: 150,
          s: 0.66,
          v: 0.30,
          a: 1
        },
        rgba: {
          r: 25,
          g: 77,
          b: 51,
          a: 1
        },
        a: 1
      },
      search: '',
      headers: [
        { text: 'text', value: 'text' }
      ],
    }
  },
  created () {
    var vm = this
    const config = {
      headers: {
        'groupId': vm.group_id
      }
    }
    vm.$nextTick(function () {
      axios.get(vm.label_api + '/' + vm.class_name  + '/' + vm.class_pk + '?full=true', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            for (var key in serializable.data) {
              vm.items.push(
                {
                  'id': serializable.data[key][vm.item_value],
                  'text': serializable.data[key][vm.item_text],
                  'selected': serializable.data[key].selected,
                  'color': serializable.data[key]['color']
                }
              )
              if (serializable.data[key].selected) {
                vm.selectedItems.push(
                  {
                    'id': serializable.data[key][vm.item_value],
                    'text': serializable.data[key][vm.item_text],
                    'selected': serializable.data[key].selected,
                    'color': serializable.data[key]['color']
                  }
                )
              } else {
                vm.unselectedItems.push(
                  {
                    'id': serializable.data[key][vm.item_value],
                    'text': serializable.data[key][vm.item_text],
                    'selected': true,
                    'color': serializable.data[key]['color']
                  }
                )
              }
            }
          }
        })
        .catch(function (error) {
          console.log(error)
        })
    })
  },
  methods: {
    showDataChange: function (item, index) {
       console.log(item)
       console.log(index)
    },
    submitLabelsData: function () {
      
      var vm = this
      if (vm.addLabel) {
        console.log(vm.labelName)
        console.log(vm.scope)
        console.log(vm.color)
      } else {
        console.log(vm.selected)
        for (var key in vm.selected) {
          vm.selectedItems.push(vm.selected[key])
          vm.unselectedItems = vm.unselectedItems.filter(function( obj ) {
            return obj.id !== vm.selected[key].id
          })
        }
        vm.selected = []
        console.log(vm.selectedItems)
      }
      
      vm.menu = false
    }
  }
}
</script>

<style>
.labels__title .list__tile__action {
      width: 100%;
}
.labels__title {
      min-width: 400px;
}
.no-padding-select .input-group--select{
  padding-top: 5px;
}
.labels__picker.card.no-shadow {
  box-shadow: none !important;
  border: 0 !important;
}
.labels__picker .table__overflow{
  max-height: 200px;
  overflow: auto;
}
.labels__picker .table__overflow tr,
.labels__picker .table__overflow td{
  border-bottom: 0 !important;
  border-top: 1px lightgray dashed;
}
.labels__picker .table__overflow td{
  padding: 10px !important;
}
.labels__picker .table__overflow td:nth-child(1){
  width: 50px;
}
.labels__picker .table__overflow td:nth-child(2){
   padding-top: 17px !important;
}
</style>
