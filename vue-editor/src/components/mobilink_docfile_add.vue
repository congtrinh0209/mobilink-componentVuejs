<template>
<v-form v-model="valid" ref="form" lazy-validation v-on:submit.prevent="preventDefaultDenine()">
  <v-alert outline color="error" icon="warning" :value="apistate=== 2">
    {{messageError}}
  </v-alert>
  <div :id="'docfile_add_'+id" class="mobilink__docfile__add layout wrap">
      <!-- Form thêm mới tài liệu lưu trữ -->
      <!-- Trích yếu -->
      <v-flex xs12 sm2 v-if="is_template=='false'&&register_type==0">
        <v-subheader class="px-0 input-group--required"><label>Trích yếu: </label> </v-subheader>
      </v-flex>
      <v-flex xs12 sm10 v-if="is_template=='false'&&register_type==0">
        <v-text-field
          placeholder="Tiêu đề "
          v-model="subject"
          :rules="subjectRules"
          required
        ></v-text-field>
      </v-flex>
      <!-- Số hiệu mẫu -->
      <v-flex xs12 sm2 v-if="is_template=='true'">
        <v-subheader class="px-0 input-group--required"><label>Số hiệu mẫu: </label> </v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template=='true'">
        <v-text-field
          placeholder="Số hiệu"
          v-model="seqNumDen"
          :rules="[v => v.length != 0 || 'Trường dữ liệu bắt buộc']"
          required
        ></v-text-field>
      </v-flex>
      <v-flex xs12 sm6  v-if="is_template=='true'">
      </v-flex>
      <!-- Tên biểu mẫu -->
      <v-flex xs12 sm2 v-if="is_template=='true'">
        <v-subheader class="px-0 input-group--required"><label>Tên biểu mẫu: </label> </v-subheader>
      </v-flex>
      <v-flex xs12 sm10 v-if="is_template=='true'">
        <v-text-field
          placeholder="Tên biểu mẫu "
          v-model="subject"
          :rules="subjectRules"
          required
        ></v-text-field>
      </v-flex>
      <!-- Loại văn bản với biểu mẫu -->
      <v-flex xs12 sm2 v-if="is_template == 'true'">
        <v-subheader class="px-0">Loại văn bản:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template == 'true'">
        <v-select
          v-bind:items="documentCatItems"
          v-model="documentCat"
          item-text="text"
          item-value="value"
          autocomplete
          return-object
          hide-selected
        ></v-select>
      </v-flex>
      <!-- Sổ theo dõi -->
      <v-flex xs12 sm2  v-if="is_template=='false'&&register_type==2">
        <v-subheader class="px-0 input-group--required"><label>Sổ theo dõi: </label></v-subheader>
      </v-flex>
      <v-flex xs12 sm4 class="layout so__theo__doi" v-if="is_template=='false'&&register_type==2">
          <v-select
            v-bind:items="templateNoItems"
            v-model="templateNo"
            item-text="subject"
            item-value="templateNo"
            autocomplete
            hide-selected
            return-object
            @change="templateNoChange($event)"
            :rules="[v => v.length != 0 || 'Trường dữ liệu bắt buộc']"
            required
          ></v-select>
      </v-flex>
      <v-flex xs12 sm6  v-if="is_template=='false'&&register_type==2">
      </v-flex>
      <!-- Số đến -->
      <v-flex xs12 sm2 v-if="is_template=='false'&&register_type==2">
        <v-subheader class="px-0 input-group--required"><label>Số đến: </label> </v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template=='false'&&register_type==2">
        <v-text-field
          class="so__den flex"
          placeholder="Số đến"
          v-model="seqNumDen"
          :rules="[v => v.length != 0 || 'Trường dữ liệu bắt buộc']"
          required
        ></v-text-field>
      </v-flex>
      <!-- Ngày đến -->
      <v-flex xs12 sm2 v-if="is_template=='false'&&register_type==2">
        <v-subheader class="px-0 input-group--required" >Ngày đến:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template=='false'&&register_type==2">
        <v-menu
          lazy
          :close-on-content-click="true"
          v-model="promulgationDateMenu"
          transition="scale-transition"
          offset-y
          full-width
          :nudge-top="40"
          max-width="290px"
          min-width="290px"
        >
          <v-text-field
            slot="activator"
            placeholder="ngày ...tháng ... năm ..."
            v-model="promulgationDate"
            @blur="promulgationDateMd = parseDate(promulgationDate)"
          ></v-text-field>
          <v-date-picker v-model="promulgationDateMd" @input="promulgationDate = formatDate($event)" autosave locale="vi">
          </v-date-picker>
        </v-menu>
      </v-flex>
      <!-- Đơn vị soạn thảo/ trình duyệt -->
      <v-flex xs12 sm2 v-if="is_template=='false'&&(register_type==1||register_type==3)">
        <v-subheader class="px-0 input-group--required">
          <label v-if="register_type==1">Đơn vị soạn thảo:</label>
          <label v-if="register_type==3">Đơn vị trình duyệt:</label>
        </v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template=='false'&&(register_type==1||register_type==3)">
        <v-select
          v-bind:items="documentCatItems"
          v-model="documentCat"
          item-text="text"
          item-value="value"
          autocomplete
          return-object
          hide-selected
          :rules="[v => v.length != 0 || 'Trường dữ liệu bắt buộc']"
          required
        ></v-select>
      </v-flex>
      <!-- Người soạn thảo/ trình duyệt -->
      <v-flex xs12 sm2 v-if="is_template=='false'&&(register_type==1||register_type==3)">
        <v-subheader class="px-0 input-group--required">
          <label v-if="register_type==1">Người soạn thảo:</label>
          <label v-if="register_type==3">Người trình duyệt:</label>
        </v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template=='false'&&(register_type==1||register_type==3)">
        <v-select
          v-bind:items="documentCatItems"
          v-model="documentCat"
          item-text="text"
          item-value="value"
          autocomplete
          return-object
          hide-selected
          :rules="[v => v.length != 0 || 'Trường dữ liệu bắt buộc']"
          required
        ></v-select>
      </v-flex>
      <!-- Tiêu đề -->
      <v-flex xs12 sm2 v-if="is_template=='false'&&(register_type==1||register_type==2)">
        <v-subheader class="px-0 input-group--required"><label>Tiêu đề: </label> </v-subheader>
      </v-flex>
      <v-flex xs12 sm10 v-if="is_template=='false'&&(register_type==1||register_type==2)">
        <v-text-field
          placeholder="Tiêu đề "
          v-model="subject"
          :rules="subjectRules"
          required
        ></v-text-field>
      </v-flex>
      <!-- Sổ theo dõi -->
      <v-flex xs12 sm2  v-if="is_template=='false'&&register_type==1">
        <v-subheader class="px-0 input-group--required">Sổ theo dõi:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 class="layout so__theo__doi" v-if="is_template=='false'&&register_type==1">
          <v-select
            v-bind:items="templateNoItems"
            v-model="templateNo"
            item-text="subject"
            item-value="templateNo"
            autocomplete
            hide-selected
            return-object
            @change="templateNoChange($event)"
            :rules="[v => v.length != 0 || 'Trường dữ liệu bắt buộc']"
            required
          ></v-select>
      </v-flex>
      <v-flex xs12 sm6  v-if="is_template=='false'&&register_type==1">
      </v-flex>
      <!--  -->

      <v-flex xs12 sm2 v-if="is_template=='false'&&register_type==0">
        <v-subheader class="px-0 input-group--required"><label>Thư mục lưu trữ: </label></v-subheader>
      </v-flex>
      <v-flex xs12 sm10 v-if="is_template=='false'&&register_type==0">
        <v-select
          v-bind:items="workspaceAddItems"
          v-model="workspaceAdd"
          item-text="name"
          item-value="workspaceId"
          autocomplete
          hide-selected
          multiple
          chips
          deletable-chips
          return-object
          :rules="[v => v.length != 0 || 'Bắt buộc phải chọn thư mục lưu trữ!']"
          required
        >
          <template slot="selection" slot-scope="data">
              <v-chip
                  close
                  @input="data.parent.selectItem(data.item)"
                  :selected="data.selected"
                  class="chip--select-multi"
                  :key="JSON.stringify(data.item)"
              >
                  {{ data.item.workspaceNamePath }}
              </v-chip>
          </template>
          <template slot="item" slot-scope="data">
            {{ data.item.workspaceNamePath }}
          </template>
        </v-select>
      </v-flex>
      <!--  -->
      <v-flex xs12 sm2 >
        <v-subheader class="px-0">Số/Ký hiệu:</v-subheader>
      </v-flex>
      <v-flex xs6 sm4 class="layout format_italic_source" >
        <v-text-field
          class="flex sm3"
          placeholder="Số"
          v-model="codeNo"
          append-icon="remove"
        ></v-text-field>
        <v-text-field
          class="flex"
          placeholder="Ký hiệu"
          v-model="codeNotation"
        ></v-text-field>
      </v-flex>
      
      <v-flex xs12 sm2 v-if="is_template == 'false'">
        <v-subheader class="px-0" v-if="register_type!=3">Ngày ban hành:</v-subheader>
        <v-subheader class="px-0" v-if="register_type==3">Ngày trình:</v-subheader>
      </v-flex>
      
      <v-flex xs12 sm4 v-if="is_template == 'false'">
        <v-menu
          lazy
          :close-on-content-click="true"
          v-model="promulgationDateMenu"
          transition="scale-transition"
          offset-y
          full-width
          :nudge-top="40"
          max-width="290px"
          min-width="290px"
        >
          <v-text-field
            slot="activator"
            placeholder="ngày ...tháng ... năm ..."
            v-model="promulgationDate"
            @blur="promulgationDateMd = parseDate(promulgationDate)"
          ></v-text-field>
          <v-date-picker v-model="promulgationDateMd" @input="promulgationDate = formatDate($event)" autosave locale="vi">
          </v-date-picker>
        </v-menu>
      </v-flex>
      <!--  -->
      <v-flex xs12 sm2 v-if="is_template == 'false'&&register_type!=3">
        <v-subheader class="px-0">Loại văn bản:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template == 'false'&&register_type!=3">
        <v-select
          v-bind:items="documentCatItems"
          v-model="documentCat"
          item-text="text"
          item-value="value"
          autocomplete
          return-object
          hide-selected
        ></v-select>
      </v-flex>
      <!--  -->
      <v-flex xs12 sm2 v-if="is_template == 'false'&&register_type!=3">
        <v-subheader class="px-0">Cơ quan ban hành:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template == 'false'&&register_type!=3">
        <v-select
          v-bind:items="issuerCodeItems"
          v-model="issuerCode"
          item-text="itemName"
          item-value="itemCode"
          autocomplete
          hide-selected
        ></v-select>
      </v-flex>
      <!-- Tóm tắt nội dung -->
      <v-flex xs12 sm2 v-if="is_template=='true'||(register_type==1||register_type==2||register_type==3)">
        <v-subheader class="px-0" v-if="is_template=='false'||(register_type==1||register_type==2||register_type==3)">Tóm tắt nội dung:</v-subheader>
        <v-subheader class="px-0" v-if="is_template=='true'">Mô tả:</v-subheader>
      </v-flex>
      <v-flex xs12 sm10 v-if="is_template=='true'||(register_type==1||register_type==2||register_type==3)">
        <v-text-field
          placeholder="Nội dung"
          textarea
          rows="2"
          v-model="content"
        ></v-text-field>
      </v-flex>
      <!--  -->
      <uploader :options="optionsForm" ref="docfileformupload" class="uploader-example mt-3 mb-2 text-left flex" v-if="is_upload == 'true'">
        <uploader-unsupport></uploader-unsupport>
        <uploader-list 
          id="404"
          developer-key='AIzaSyAouTfMdrvMHjAwvF9RVsvwsuN1WSzGjmM'
          client-id='790244148120-0grj2n5evkij0kqqthkbtgb18i0gup1j.apps.googleusercontent.com'
          view-id='DOCS'
          :class_name="class_name"
          :class_pk="class_pk"
          :group_id="groupId"
          :file_attach_api="file_attach_api"
          extensions_upload="false"
          permission="write"
        ></uploader-list>
      </uploader>
      
      <!-- <v-flex xs12 sm2 class="hidden_fak_temp" v-if="is_template == 'false'">
        <v-subheader class="px-0">Loại sổ:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 class="hidden_fak_temp" v-if="is_template == 'false'">
        <v-radio-group v-model="register" row @change="registerChange($event)">
          <v-radio label="khác" value="0" ></v-radio>
          <v-radio label="đi" value="1" ></v-radio>
          <v-radio label="đến" value="2"></v-radio>
        </v-radio-group>
      </v-flex>
       -->
      
      <!-- <v-flex xs12 sm2 v-if="is_template == 'false'">
        <v-subheader class="pr-0">Ngày phát hành:</v-subheader>
      </v-flex>
      
      <v-flex xs12 sm4 v-if="is_template == 'false'">
        <v-menu
          lazy
          :close-on-content-click="true"
          v-model="registerDateMenu"
          transition="scale-transition"
          offset-y
          full-width
          :nudge-top="40"
          max-width="290px"
          min-width="290px"
        >
          <v-text-field
            slot="activator"
            placeholder="ngày ...tháng ... năm ..."
            v-model="registerDate"
            @blur="registerDateMd = parseDate(registerDate)"
          ></v-text-field>
          <v-date-picker v-model="registerDateMd" @input="registerDate = formatDate($event)" autosave locale="vi">
          </v-date-picker>
        </v-menu>
      </v-flex> -->
      
      

      <!-- <v-flex xs12 sm2 v-if="is_template == 'false'">
        <v-subheader class="pr-0">Người ký:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template == 'false'">
        <v-text-field
          placeholder="cập nhật tên người ký ... "
          v-model="signerInfo"
        ></v-text-field>
      </v-flex> -->

      <!-- <v-flex xs12 sm2 class="hidden_fak_temp" v-if="is_template == 'false'">
        <v-subheader class="px-0">Trạng thái:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 class="hidden_fak_temp" v-if="is_template == 'false'">
        <v-radio-group v-model="status" row>
          <v-radio label="Không phải xử lý" value="0" ></v-radio>
          <v-radio label="Phải xử lý" value="1"></v-radio>
        </v-radio-group>
      </v-flex>

      <v-flex xs12 sm2 class="hidden_fak_temp" v-if="is_template == 'false'">
        <v-subheader class="pr-0">Hạn xử lý:</v-subheader>
      </v-flex>
      
      <v-flex xs12 sm4 class="hidden_fak_temp" v-if="is_template == 'false'">
        <v-menu
          lazy
          :close-on-content-click="true"
          v-model="dueDateMenu"
          transition="scale-transition"
          offset-y
          full-width
          :nudge-top="40"
          max-width="290px"
          min-width="290px"
        >
          <v-text-field
            slot="activator"
            placeholder="ngày ...tháng ... năm ..."
            v-model="dueDate"
            @blur="dueDateMd = parseDate(dueDate)"
          ></v-text-field>
          <v-date-picker v-model="dueDateMd" @input="dueDate = formatDate($event)" autosave locale="vi">
          </v-date-picker>
        </v-menu>
      </v-flex>

        
      <v-flex xs12 sm2 class="hidden_fak_temp" v-if="is_template == 'false'">
        <v-subheader class="px-0">Tóm tắt nội dung:</v-subheader>
      </v-flex>
      <v-flex xs12 sm10 class="hidden_fak_temp">
        <v-text-field
          placeholder="Nội dung"
          textarea
          rows="2"
          v-model="content"
        ></v-text-field>
      </v-flex>
    
      <v-flex xs12 sm2 v-if="is_template == 'true'">
        <v-subheader class="px-0">Loại sổ:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template == 'true'">
        <v-radio-group v-model="register" row @change="registerChange($event)">
          <v-radio label="khác" value="0" ></v-radio>
          <v-radio label="đi" value="1" ></v-radio>
          <v-radio label="đến" value="2"></v-radio>
        </v-radio-group>
      </v-flex>
       <v-flex xs12 sm2 v-if="is_template == 'true'">
        <v-subheader class="pr-0">Số hiệu sổ:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template == 'true'">
          <v-text-field
          v-model="templateNoTemplate"
        ></v-text-field>
      </v-flex>

      <v-flex xs12 sm2 v-if="is_template == 'true'">
        <v-subheader class="px-0">Tên sổ:</v-subheader>
      </v-flex>
      <v-flex xs12 sm10 v-if="is_template == 'true'">
        <v-text-field
          placeholder="Tiêu đề "
          v-model="subject"
          required
        ></v-text-field>
      </v-flex>

      <v-flex xs12 sm2 v-if="is_template == 'true'">
        <v-subheader class="px-0">Số/Ký hiệu:</v-subheader>
      </v-flex>
      <v-flex xs6 sm4 class="layout format_italic_source" v-if="is_template == 'true'">
        <v-text-field
          class="flex sm3"
          placeholder="Số"
          v-model="codeNo"
          append-icon="remove"
        ></v-text-field>
        <v-text-field
          class="flex"
          placeholder="Ký hiệu"
          v-model="codeNotation"
        ></v-text-field>
      </v-flex>

      <v-flex xs12 sm2 v-if="is_template == 'true'">
        <v-subheader class="pr-0">Loại văn bản:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 v-if="is_template == 'true'">
        <v-select
          v-bind:items="documentCatItems"
          v-model="documentCat"
          item-text="text"
          item-value="value"
          autocomplete
          return-object
          hide-selected
        ></v-select>
      </v-flex>

      <v-flex xs12 sm2 v-if="is_template == 'true'">
        <v-subheader class="px-0">Tóm tắt nội dung:</v-subheader>
      </v-flex>
      <v-flex xs12 sm10 v-if="is_template == 'true'">
        <v-text-field
          placeholder="Nội dung"
          textarea
          rows="2"
          v-model="content"
        ></v-text-field>
      </v-flex> -->

  </div>
</v-form>
</template>

<script>
const COMPONENT_NAME = 'jx-mobilink-docfile-add'

export default {
  name: COMPONENT_NAME,
  props: {
    id: null,
    class_pk: null,
    class_name: null,
    group_id: null,
    register_type:0,
    is_template: 'false',
    is_upload: 'false',
    file_attach_api: 'http://127.0.0.1:8081/api/fileattachs',
    workspace_cur: 0,
    current_user_id: 0
  },
  watch: {
    workspace_cur(){
      var vm = this
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      vm.workspaceAdd = []
      axios.get('http://127.0.0.1:8081/api/workspaces?editable=true', config)
      .then(function (response) {
        var serializable = response.data
        if (serializable.hasOwnProperty('data')) {
          for (var key in serializable.data) {
            serializable.data[key]['permanent'] = true
            vm.workspaceAddItems.push(serializable.data[key])
            if (vm.workspace_cur == serializable.data[key].workspaceId) {
              vm.workspaceAdd.push(serializable.data[key])
            }
          }
        }
      })
      .catch(function (error) {
        console.log(error)
      })
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
      vm.register = '0'
      if (vm.is_template) {
      } else {
        
        axios.get('http://127.0.0.1:8081/api/docfiles?register=0&template=1', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.templateNoItems = serializable.data
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      }

      axios.get('http://127.0.0.1:8081/api/dictcollections/DOCUMENT_TYPE/dictitems?sort=treeIndex', config)
      .then(function (response) {
        var serializable = response.data
        if (serializable.hasOwnProperty('data')) {
          for (var key in serializable.data) {
            if (serializable.data[key].level === 0) {
              vm.documentCatItems.push({
                header: serializable.data[key].itemName
              })
            } else {
              vm.documentCatItems.push({
                text: serializable.data[key].itemName,
                value: serializable.data[key].itemCode
              })
            }
          }
        }
      })
      .catch(function (error) {
        console.log(error)
      })

      axios.get('http://127.0.0.1:8081/api/dictcollections/GOVERMENT_AGENCY/dictitems' + '?level=0', config)
      .then(function (response) {
        var serializable = response.data
        if (serializable.hasOwnProperty('data')) {
          vm.issuerCodeItems = serializable.data
        }
      })
      .catch(function (error) {
        console.log(error)
      })
      vm.workspaceAdd = []
      axios.get('http://127.0.0.1:8081/api/workspaces?editable=true', config)
      .then(function (response) {
        var serializable = response.data
        if (serializable.hasOwnProperty('data')) {
          for (var key in serializable.data) {
            serializable.data[key]['permanent'] = true
            vm.workspaceAddItems.push(serializable.data[key])
            if (vm.workspace_cur == serializable.data[key].workspaceId) {
              vm.workspaceAdd.push(serializable.data[key])
            }
          }
        }
      })
      .catch(function (error) {
        console.log(error)
      })

    })
  },
  data () {
    
    return {
      groupId: this.group_id,
      valid: true,
      subjectRules: [
        (v) => !!v || 'Trích yếu bắt buộc phải nhập!'
      ],
      seqNumDen: null,
      is_so_den: false,
      optionsForm: {
        target: 'http://127.0.0.1:8081/api/fileattachs/upload/'+this.class_name+'/0/'+this.group_id,
        chunkSize: 100*1024*1024,
        headers: {
          'groupId': this.group_id
        }
      },
      apistate: 0,
      messageError: 'error',
      register: '0',
      templateNoItems: [],
      templateNo: '',
      templateNoTemplate: '',
      documentCatItems: [],
      documentCat: {},
      registerItems: [
        {text:"Văn bản chung ",value:0},
        {text:"Văn bản đến ",value:1},
        {text:"Văn bản đi ",value:2},
        {text:"Văn bản hợp đồng",value:3}
      ],
      status: '0',
      signerInfo: '',
      seqNum: 0,
      registerDate: '',
      registerDateMd:'',
      registerDateMenu: false,
      dueDate: '',
      dueDateMd:'',
      dueDateMenu: false,
      codeNo:'',
      codeNotation: '',
      subject: '',
      issuerCodeItems: [],
      issuerCode: '',
      promulgationDate: '',
      promulgationDateMd:'',
      promulgationDateMenu: false,
      content: '',
      snackbarStatus: false,
      snackbarerorStatus: false,
      docfile_hidden_loading: false,
      workspaceAddItems: [],
      workspaceAdd: []
    }
  },
  methods: {
    preventDefaultDenine () {
      
    },
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
    customeDateStr: function (dateStr) {
      var dateCur = new Date(dateStr)
      var month = dateCur.getMonth() + 1
      var day = dateCur.getDate()
      var year = dateCur.getFullYear()
      if (day < 10) {
        day = '0' + day;
      }
      if (month < 10) {
        month = '0' + month;
      }
      return day + "/" + month + "/" + year
    },
    createDocFileSubmit: function () {
      var vm = this
      console.log(vm.workspaceAdd.length)
      console.log(vm.group_id)
      if (this.$refs.form.validate()) {

        const config = {
          headers: {
            'groupId': vm.group_id
          }
        }
        var params = new URLSearchParams()
        params.append('documentCat', vm.documentCat.value)
        
        if (vm.is_upload == 'true') {
          params.append('templateNo', vm.templateNo.templateNo)
        } else {
          params.append('templateNo', vm.templateNoTemplate)
        }
        if (typeof vm.seqNum == 'undefined') {
          vm.seqNum = 0
        }
        if (typeof vm.content == 'undefined') {
          vm.content = ''
        }
        params.append('register', vm.register)
        params.append('seqNum', vm.seqNum)

        const [day, month, year] = vm.registerDate
        var registerDateData = ''
        if (vm.registerDate != null && vm.registerDate.length > 0) {
          registerDateData = year +""+ month +""+ day
        }
        params.append('registerDate', registerDateData)
        params.append('codeNo', vm.codeNo)
        params.append('codeNotation', vm.codeNotation)
        params.append('subject', vm.subject)
        params.append('issuerCode', vm.issuerCode)
        const [dayp, monthp, yearp] = vm.promulgationDate
        var promulgationDateData = ''
        if (vm.promulgationDate != null && vm.promulgationDate.length > 0) {
          promulgationDateData = yearp +""+ monthp +""+ dayp
        }
        params.append('promulgationDate', promulgationDateData)
        params.append('content', vm.content)
        if (vm.is_upload == 'true') {
          
        } else {
          params.append('isTemplate', 1)
        }
        console.log('check submit')
        console.log(vm.$refs['docfileformupload'].fileList != null && vm.$refs['docfileformupload'].fileList.length > 0)

        if (vm.$refs['docfileformupload'].fileList != null && vm.$refs['docfileformupload'].fileList.length > 0) {
          axios.post('http://127.0.0.1:8081/api/docfiles',
            params,
            config
          )
          .then(function (response) {
            
            vm.$emit('call-back', response.data.docFileId)

            var paramsApi2 = new URLSearchParams()
            paramsApi2.append('workspaces', JSON.stringify(vm.workspaceAdd))
            paramsApi2.append('className', vm.class_name)
            paramsApi2.append('classPK', response.data.docFileId)
            axios.post('http://127.0.0.1:8081/api/resourceworkspaces/update',
              paramsApi2,
              config
            )
            .then(function (response) {
              
            })
            .catch(function (error) {
              vm.apistate = 2
              setTimeout(
                function(){ 
                  vm.apistate = 0
                }, 
              3000)
            })
            
            var paramsApi2 = new URLSearchParams()
            paramsApi2.append('workspaces', JSON.stringify(vm.workspaceAdd))
            paramsApi2.append('className', vm.class_name)
            paramsApi2.append('classPK', response.data.docFileId)
            axios.post('http://127.0.0.1:8081/api/resourceworkspaces/update',
              paramsApi2,
              config
            )
            .then(function (response) {
              
            })
            .catch(function (error) {
              vm.apistate = 2
              setTimeout(
                function(){ 
                  vm.apistate = 0
                }, 
              3000)
            })
            
          })
          .catch(function (error) {
            vm.apistate = 2
            vm.messageError = error.response.data.message
            setTimeout(
              function(){ 
                vm.apistate = 0
              }, 
            3000)
          })
        } else {
          alert('Tài liệu bắt buộc phải chọn!');
        }
        
      }
      
    },
    templateNoChange: function (item) {
      var vm = this
      console.log(item)
      vm.documentCat = item.documentCat
      vm.seqNumDen = item.seqNum
      vm.seqNum = item.seqNum
      vm.codeNo = item.codeNo
      vm.codeNotation = item.codeNotation
      vm.subject = item.subject
      vm.signerInfo = item.signerInfo
      vm.issuerCode = item.issuerCode
      try {
         if (item.promulgationDate.length > 0) {
          vm.promulgationDate = vm.customeDateStr(item.promulgationDate)
        }
      } catch (error) {
        console.log(error)
      }
     try {
         if (item.registerDate.length > 0) {
          vm.registerDate = vm.customeDateStr(item.registerDate)
        }
      } catch (error) {
        console.log(error)
      }
      try {
         if (item.dueDate.length > 0) {
          vm.dueDate = vm.customeDateStr(item.dueDate)
        }
      } catch (error) {
        console.log(error)
      }
      vm.content = item.content
    },
    registerChange: function (item) {
      var vm = this
      console.log(item)
      console.log(item == 1)
      if (item == 2) {
        vm.is_so_den = true
      } else {
        vm.is_so_den = false
      }
      
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      vm.templateNoItems = []
      axios.get('http://127.0.0.1:8081/api/docfiles?template=1&register='+item+'&sort=subject', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            for (var key in serializable.data) {
              serializable.data[key]['permanent'] = true
              if (serializable.data[key]['permission'] === 'write' || serializable.data[key]['permission'] === 'owner') {
                vm.templateNoItems.push(serializable.data[key])
              }
            }
          } else {
            vm.templateNoItems = []
          }
        })
        .catch(function (error) {
          console.log(error)
        })
    }
  }
}
</script>

<style>
  .mobilink__docfile__add .input-group{
    padding-top: 9px;
  }
  .mobilink__docfile__add .input-group .radio,
  .mobilink__docfile__add .input-group .radio label {
    padding: 0;
    margin: 0;
  }
  .format_italic_source .material-icons{
    transform: rotate(110deg);
  }
  .mobilink-shared-root.editable-wrap.editable-wrap-before-select .input-group--chips label{
      display: block;
  }
  .mobilink__docfile__add.layout > .flex:nth-child(1){
      -webkit-box-ordinal-group: 2;
    -ms-flex-order: 1;
    order: 1;
}
.mobilink__docfile__add.layout > .flex:nth-child(2){
      -webkit-box-ordinal-group: 3;
    -ms-flex-order: 2;
    order: 2;
}
.mobilink__docfile__add.layout > .flex:nth-child(3){
      -webkit-box-ordinal-group: 4;
    -ms-flex-order: 3;
    order: 3;
}
.mobilink__docfile__add.layout > .flex:nth-child(4){
      -webkit-box-ordinal-group: 5;
    -ms-flex-order: 4;
    order: 4;
}
.mobilink__docfile__add.layout > .flex:nth-child(5){
      -webkit-box-ordinal-group: 6;
    -ms-flex-order: 5;
    order: 5;
}
.mobilink__docfile__add.layout > .flex:nth-child(6){
      -webkit-box-ordinal-group: 7;
    -ms-flex-order: 6;
    order: 6;
}
.mobilink__docfile__add.layout > .flex:nth-child(7){
      -webkit-box-ordinal-group: 8;
    -ms-flex-order: 7;
    order: 7;
}
.mobilink__docfile__add.layout > .flex:nth-child(8){
      -webkit-box-ordinal-group: 9;
    -ms-flex-order: 8;
    order: 8;
}
.mobilink__docfile__add.layout > .flex:nth-child(9){
      -webkit-box-ordinal-group: 10;
    -ms-flex-order: 9;
    order: 9;
}
.mobilink__docfile__add.layout > .flex:nth-child(10){
      -webkit-box-ordinal-group: 11;
    -ms-flex-order: 10;
    order: 10;
}
.mobilink__docfile__add.layout > .flex:nth-child(11){
      -webkit-box-ordinal-group: 12;
    -ms-flex-order: 11;
    order: 11;
}
.mobilink__docfile__add.layout > .flex:nth-child(12){
      -webkit-box-ordinal-group: 13;
    -ms-flex-order: 12;
    order: 12;
}
.mobilink__docfile__add.layout > .flex:nth-child(13){
      -webkit-box-ordinal-group: 2;
    -ms-flex-order: 1;
    order: 13;
}
.mobilink__docfile__add.layout > .flex:nth-child(14){
      -webkit-box-ordinal-group: 3;
    -ms-flex-order: 2;
    order: 14;
}
.mobilink__docfile__add.layout > .flex:nth-child(15){
      -webkit-box-ordinal-group: 16;
    -ms-flex-order: 15;
    order: 15;
}
.mobilink__docfile__add.layout > .flex:nth-child(16){
      -webkit-box-ordinal-group: 17;
    -ms-flex-order: 16;
    order: 16;
}
.mobilink__docfile__add.layout > .flex:nth-child(17){
      -webkit-box-ordinal-group: 18;
    -ms-flex-order: 17;
    order: 17;
}
.mobilink__docfile__add.layout > .flex:nth-child(18){
    -webkit-box-ordinal-group: 19;
    -ms-flex-order: 18;
    order: 18;
}
.mobilink__docfile__add.layout > .flex:nth-child(19){
      -webkit-box-ordinal-group: 20;
    -ms-flex-order: 19;
    order: 19;
}
.mobilink__docfile__add.layout > .flex:nth-child(20){
    -webkit-box-ordinal-group: 21;
    -ms-flex-order: 20;
    order: 20;
}
.mobilink__docfile__add.layout > .flex:nth-child(21){
      -webkit-box-ordinal-group: 22;
    -ms-flex-order: 21;
    order: 21;
}
.mobilink__docfile__add.layout > .flex:nth-child(22){
      -webkit-box-ordinal-group: 23;
    -ms-flex-order: 22;
    order: 22;
}
.mobilink__docfile__add.layout > .flex:nth-child(23){
      -webkit-box-ordinal-group: 4;
    -ms-flex-order: 3;
    order: 23;
}
.mobilink__docfile__add.layout > .flex:nth-child(24){
    -webkit-box-ordinal-group: 5;
    -ms-flex-order: 4;
    order: 24;
}
.mobilink__docfile__add.layout > .flex:nth-child(25){
      -webkit-box-ordinal-group: 26;
    -ms-flex-order: 25;
    order: 25;
}
.mobilink__docfile__add.layout > .flex:nth-child(26){
      -webkit-box-ordinal-group: 27;
    -ms-flex-order: 26;
    order: 26;
}
.mobilink__docfile__add.layout > .flex:nth-child(27){
      -webkit-box-ordinal-group: 5;
    -ms-flex-order: 4;
    order: 27;
}
</style>