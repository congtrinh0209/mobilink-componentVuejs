<template>
  <v-card class="status--mobilink">
    <v-card-title>
      <div class="box-panel status-w100 pr-0">
        <v-layout class="wrap">
  
          <v-flex xs12 sm3>
            <v-subheader class="pl-0">Trạng thái:</v-subheader>
          </v-flex>
          <v-flex xs12 sm9 :class="{'mobilink-status-root editable-wrap editable-wrap-before-select': permission !== 'write' && permission !== 'owner'}">
            <v-select
              v-bind:items="items"
              v-model="mobilinkStatus"
              :item-text="itemText"
              :item-value="itemValue"
              hide-selected
              single-line
              @change="statusSubmit($event, 1)"
            ></v-select>
          </v-flex>
  
        </v-layout>
        <v-layout class="wrap">
  
          <v-flex xs12 sm3>
            <v-subheader class="pl-0">Hạn xử lý:</v-subheader>
          </v-flex>
          <v-flex xs12 sm9>
            <div v-if="statusEdit" style="position: relative;" class="status--mobilink--actions">
              <v-menu
                lazy
                :close-on-content-click="false"
                v-model="menu"
                transition="scale-transition"
                offset-y
                full-width
                :nudge-right="40"
                max-width="290px"
                min-width="290px"
              >
                <v-text-field
                  slot="activator"
                  placeholder="ngày ...tháng ... năm ..."
                  v-model="dateFormatted"
                  @blur="date = parseDate(dateFormatted)"
                ></v-text-field>
                <v-date-picker v-model="date" @input="dateFormatted = formatDate($event)" autosave locale="vi">
                  
                </v-date-picker>
              </v-menu>
              <v-btn flat icon class="btn--editable btn--editable--done" v-on:click.native="statusSubmit(2)">
                  <v-icon>done</v-icon>
                </v-btn>
                <v-btn flat icon v-on:click.native="statusEdit = !statusEdit" class="btn--editable btn--editable--clear">
                  <v-icon color="red darken-3">clear</v-icon>
                </v-btn>
            </div>
            
            <div v-else class="status--mobilink--actions">
              <i class="text-gray" v-if="date == null">Chưa có</i>
               <i class="text-gray" v-else>{{dateFormatted}}</i>
              <v-btn v-if="permission === 'write' || permission === 'owner'" flat icon v-on:click.native="statusEdit = !statusEdit" class="btn--editable">
                <v-icon>edit</v-icon>
              </v-btn>
            </div>
          </v-flex>
  
        </v-layout>
      </div>
    </v-card-title>
    <v-snackbar :timeout="2000" :top="true" :bottom="false" :right="true" :left="false" :multi-line="true" :vertical="false" v-model="snackbarStatus"
        class="snackbar-success" >
      <v-icon flat color="white">check_circle</v-icon> Yêu cầu của bạn được thực hiện thành công!
      <v-btn flat fab mini color="white" @click.native="ssnackbarStatus = false">Tắt</v-btn>
    </v-snackbar>
    <v-snackbar :timeout="2000" :top="true" :bottom="false" :right="false" :left="false" :multi-line="true" :vertical="false" v-model="snackbarerorStatus"
        class="snackbar-error" >
      <v-icon flat color="white">check_circle</v-icon> Yêu cầu của bạn được thực hiện thất bại!
      <v-btn flat fab mini color="white" @click.native="snackbarerorStatus = false">Tắt</v-btn>
    </v-snackbar>
  </v-card>
</template>

<script>
import axios from 'axios'
const COMPONENT_NAME = 'jx-mobilink-status'

export default {
  name: COMPONENT_NAME,
  props: {
    class_pk: null,
    class_name: null,
    group_id: null,
    update_api: '',
    items: [],
    itemText: '',
    itemValue: '',
    statusKey: '',
    dateKey: '',
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
      snackbarerorStatus: false
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
      vm.mobilinkStatus = 0
      axios.get(vm.update_api + '/' + vm.class_pk, config)
        .then(function (response) {
          var serializable = response.data
            vm.mobilinkStatus = serializable[vm.statusKey]
            console.log(vm.mobilinkStatus)
            if (serializable[vm.dateKey] != '') {
              var dateCur = new Date(serializable[vm.dateKey])
              var month = dateCur.getMonth() + 1;
              var day = dateCur.getDate() ;
              var year = dateCur.getFullYear();
              var hour = dateCur.getHours();
              if (day < 10) {
                day = '0' + day;
              }
              if (month < 10) {
                month = '0' + month;
              }
              if (hour < 10) {
                hour = '0' + hour;
              }
              vm.dateFormatted = vm.formatDate(year + '-' + month + '-' + day)
              vm.date = year + '-' + month + '-' + day
            }
        })
        .catch(function (error) {
          console.log(error)
        })
    })
  },
  methods: {
    formatDate (date) {
      if (!date) {
        return null
      }
      const [year, month, day] = date.split('-')
      return `${day}/${month}/${year}`
    },
    parseDate (date) {
      if (!date) {
        return null
      }
      const [day, month, year] = date.split('/')
      return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
    },
    statusSubmit: function (data, state) {
      var vm = this
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      var dateCur = new Date(vm.date);
      var month = dateCur.getMonth() + 1;
      var day = dateCur.getDate() ;
      var year = dateCur.getFullYear();
      var hour = dateCur.getHours();
      if (day < 10) {
        day = '0' + day;
      }
      if (month < 10) {
        month = '0' + month;
      }
      if (hour < 10) {
        hour = '0' + hour;
      }
      var params = new URLSearchParams()
      if (state === 1) {
        params.append('status', data)
      } else {
        params.append('dueDate', year+month+day)
      }
      axios.put(vm.update_api + '/' + vm.class_pk,
        params,
        config
      )
      .then(function (response) {
        vm.statusEdit = !vm.statusEdit
        vm.mobilinkStatus = response.data.status
        vm.snackbarStatus = true
      })
      .catch(function (error) {
        console.log(error)
        vm.snackbarerorStatus = true
      })
    }
  }
}
</script>

<style>

.status-w100 {
  width: 100%;
}
.status--mobilink .input-group--single-line{
  padding-top: 8px;
}
.status--mobilink .input-group__details {
      min-height: 10px;
}
.status--mobilink--actions {
  line-height: 50px;
  position: relative;
}
.status--mobilink--actions .btn--editable {
    position: absolute;
    right: 0px;
    margin: 0;
    top: 4px;
}
.status--mobilink--actions .btn--editable i{
  font-size: 17px;
}
.status--mobilink--actions .btn--editable--done {
    top: 4px;
    right: 40px !important;
}
.status--mobilink--actions .btn--editable--clear {
    top: 4px;
    right: 0 !important;
}
.status--mobilink--actions .menu__activator > div.input-group--text-field{
    padding-top: 10px
}
.mobilink-status-root.editable-wrap.editable-wrap-before-select .input-group {
      padding-top: 9px;
}
</style>
