<template>
  <div style="position: relative;">
  <v-expansion-panel expand>
    <v-expansion-panel-content v-bind:value="expanded">
      <div slot="header">
        <div class="custome-panel-heading-with-icon">
          <div >{{title}}
          </div> 
          <div class="text-lg-right">
            <v-btn fab small
              @click.stop="addByFastForm = !addByFastForm"
            >
              <v-icon>plus_one</v-icon>
            </v-btn>
          </div>
          </div>
      </div>
      <div class="mobilink--checklist">
            <div >
              <v-layout wrap>
                <v-flex xs12 sm6>
                  123
                </v-flex>
                <v-flex xs12 sm3>
                  234
                </v-flex>
                <v-flex xs12 sm3>
                  456
                </v-flex>
              </v-layout>
            </div>
            <div >
              <v-form v-model="valid" ref="form" lazy-validation v-if="addByFastForm" >
                <v-layout wrap>
                  <v-flex xs12 sm6>
                    <v-text-field
                        placeholder="Ten cong viec"
                        v-model="fastSubject"
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-text-field>
                  </v-flex>
                  <v-flex xs12 sm3>
                    <v-select
                      v-bind:items="item"
                      v-model="fastDoer"
                      clearable
                      item-text="checklistId"
                      item-value="checklistId"
                      autocomplete
                      return-object
                      hide-selected
                      :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
						          required
                  ></v-select>
                  </v-flex>
                  <v-flex xs12 sm3>
                    <div style="padding-top:15px">
                      <date-picker v-model="fastDueDate" 
                        placeholder="Ngày nộp hồ sơ đến" 
                        lang="en" 
                        type="datetime" 
                        format="dd/MM/yyy hh:mm:ss" confirm>
                      </date-picker>
                    </div>
                  </v-flex>
                  <v-flex xs12 sm12 class="text-lg-right">
                    <v-btn>
                      <v-icon>save</v-icon>
                      <span v-lang.luu_lai></span>
                    </v-btn>
                  </v-flex>
                </v-layout>
              </v-form>
            </div>
            <div :key="index" v-for="(item, index) in items" >
              <v-divider v-if="index>0" :inset="true" ></v-divider>
              
                    <v-layout wrap>
                      <v-flex xs12 sm6>
                        {{item.doItem}}
                      </v-flex>
                      <v-flex xs6 sm3>
                        {{item.doerName}}
                      </v-flex>
                      <v-flex xs6 sm3>
                        {{getMoment(item.dueDate).format('HH:mm DD/MM/YYYY')}}
                      </v-flex>
                      <v-flex xs12 sm12>
                        <b>ghi chu: </b>{{item.checklistId}}
                      </v-flex>
                      <v-flex xs12 sm9>
                        {{item.checklistId}}
                        atachhhhhhhhhhhhhhhhhhhhhhhhh
                      </v-flex>
                      <v-flex xs12 sm3>
                        {{item.checklistId}}
                        danh gia
                      </v-flex>
                    </v-layout>
            </div>


      </div>
    </v-expansion-panel-content>
  </v-expansion-panel>
  <v-dialog v-model="checklistDialog" persistent max-width="900" transition="fade-transition">
    <v-card :class="{'mobilink-shared-root editable-wrap editable-wrap-before-select': permission !== 'write' && permission !== 'owner'}">
        <v-card-title class="px-0 py-0" style="background-color: rgb(214, 233, 247);min-height: 43px;position: fixed;max-width: 900px;width: 100%;z-index: 9999;">
            <span class="pl-3">Cập nhật công việc</span>
            <v-spacer></v-spacer>
            
            <div class="menu" style="display: inline-block;">
                <div class="menu__activator">
                    <v-btn icon slot="activator" @click.native="checklistDialog = false">
                        <v-icon>close</v-icon>
                    </v-btn>
                </div>
            </div>

        </v-card-title>
        <v-card-text class="voting__add" style="padding-top: 65px;">
          <v-layout wrap>
            <v-flex xs12 sm2>
              <v-subheader class="px-0">Kế hoạch năm:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
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
                  placeholder="ngày ... tháng ... năm"
                  v-model="date"
                  readonly
                ></v-text-field>
                <v-date-picker type="month" v-model="date" no-title scrollable actions>
                  <template slot-scope="{ save, cancel }">
                    <v-card-actions>
                      <v-spacer></v-spacer>
                      <v-btn flat color="primary" @click="cancel">Cancel</v-btn>
                      <v-btn flat color="primary" @click="save">OK</v-btn>
                    </v-card-actions>
                  </template>
                </v-date-picker>
              </v-menu>
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="pr-0">Tháng:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="px-0">Tên công việc:</v-subheader>
            </v-flex>
            <v-flex xs12 sm10>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="px-0">Người giao:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="pr-0">Người thực hiện:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="px-0">Hạn xử lý:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="pr-0">Trạng thái:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="px-0">Ghi chú:</v-subheader>
            </v-flex>
            <v-flex xs12 sm10>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="px-0">Thời gian dự kiến:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="pr-0">Thời gian thực tế:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="px-0">Kết quả đánh giá:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
              
            </v-flex>
            <v-flex xs12 sm2>
              <v-subheader class="pr-0">Quá hạn:</v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
              
            </v-flex>
          </v-layout>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
        </v-card-actions>

      </v-card>
  </v-dialog>
  <v-btn flat icon class="expansion__plus__btn" v-if="permission === 'write' || permission === 'owner'" v-on:click.native="checklistDialog = !checklistDialog" >
    <v-icon>add_circle</v-icon>
  </v-btn>
  </div>
</template>

<script>
const COMPONENT_NAME = 'jx-mobilink-checklist'
import moment from 'moment';
import DatePicker from 'vue2-datepicker'

export default {
  name: COMPONENT_NAME,
  props: {
    id: null,
    class_pk: null,
    class_name: null,
    group_id: null,
    album_api: '',
    permission: 'read'
  },
  components: { DatePicker },
  data () {
    return {
      checklistDialog: false,
      date: null,
      menu: false,
      modal: false,
      title: 'Danh sach nhiem vu con',
      items: [],
      validFastForm: '',
      addByFastForm: false,
      fastDueDate: '',
    }
  },
  created() {
    let vm = this
    axios.get( 'http://127.0.0.1:8081/api/' + 'activities/id/checklists', {})
      .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
              vm.items = serializable.data
          }
      })
      .catch(function (error) {
          console.log(error)
      })
  },
  methods: {
    getMoment (date) {
      return moment(date)
    }
  }
}
</script>

<style>
	.custome-panel-heading-with-icon {
	    display: -webkit-flex; /* Safari */
	    -webkit-align-items: center; /* Safari 7.0+ */
	    display: flex;
	    align-items: center;
	}
	.custome-panel-heading-with-icon div {
	   -webkit-flex: 1; /* Safari 6.1+ */
	   flex: 1;
	}
</style>