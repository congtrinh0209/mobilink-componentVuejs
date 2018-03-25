<template>
  <div :id="'docfile_add_'+id" class="mobilink__docfile__add">
    
    <v-layout wrap v-if="is_template == 'false'">
      <v-flex xs12 sm2>
        <v-subheader class="px-0">Loại sổ:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4>
        <v-radio-group v-model="register" row @change="registerChange($event)">
          <v-radio label="Tài liệu đi" value="0" ></v-radio>
          <v-radio label="Tài liệu đến" value="1"></v-radio>
        </v-radio-group>
      </v-flex>
       <v-flex xs12 sm2>
        <v-subheader class="pr-0">Sổ theo dỗi:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4 class="layout so__theo__doi">
        <div class="flex xs12" style="
            display: flex;
            display: -webkit-flex;
        ">
          <v-select
            v-bind:items="templateNoItems"
            v-model="templateNo"
            item-text="subject"
            item-value="templateNo"
            autocomplete
            hide-selected
            @change="templateNoChange($event)"
          ></v-select>
          <v-text-field
          v-if="is_so_den"
          class="so__den flex sm3 pl-2"
          placeholder="Số đến"
          v-model="seqNumDen"
        ></v-text-field>
        
        </div>
      </v-flex>
      <v-flex xs12 sm2>
        <v-subheader class="px-0">Số/Ký hiệu:</v-subheader>
      </v-flex>
      <v-flex xs6 sm4 class="layout format_italic_source">
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

      <v-flex xs12 sm2>
        <v-subheader class="pr-0">Loại văn bản:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4>
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

      <v-flex xs12 sm2>
        <v-subheader class="px-0">Ngày ban hành:</v-subheader>
      </v-flex>
      
      <v-flex xs12 sm4>
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

      <v-flex xs12 sm2>
        <v-subheader class="pr-0">Ngày phát hành:</v-subheader>
      </v-flex>
      
      <v-flex xs12 sm4>
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
      </v-flex>
      
      <v-flex xs12 sm2>
        <v-subheader class="px-0">Tiêu đề văn bản:</v-subheader>
      </v-flex>
      <v-flex xs12 sm10>
        <v-text-field
          placeholder="Tiêu đề "
          v-model="subject"
        ></v-text-field>
      </v-flex>

      <v-flex xs12 sm2>
        <v-subheader class="px-0">Cơ quan ban hành:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4>
        <v-select
          v-bind:items="issuerCodeItems"
          v-model="issuerCode"
          item-text = "itemName"
          item-value = "itemCode"
          autocomplete
          hide-selected
        ></v-select>
      </v-flex>

      <v-flex xs12 sm2>
        <v-subheader class="pr-0">Người ký:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4>
        <v-text-field
          placeholder="cập nhật tên người ký ... "
          v-model="signerInfo"
        ></v-text-field>
      </v-flex>

      <v-flex xs12 sm2>
        <v-subheader class="px-0">Trạng thái:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4>
        <v-radio-group v-model="status" row>
          <v-radio label="Không phải xử lý" value="0" ></v-radio>
          <v-radio label="Phải xử lý" value="1"></v-radio>
        </v-radio-group>
      </v-flex>

      <v-flex xs12 sm2>
        <v-subheader class="pr-0">Hạn xử lý:</v-subheader>
      </v-flex>
      
      <v-flex xs12 sm4>
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

      <v-flex xs12 sm2>
        <v-subheader class="px-0">Thư mục lưu trữ:</v-subheader>
      </v-flex>
      <v-flex xs12 sm10>
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
        ></v-select>
      </v-flex>
        
      <v-flex xs12 sm2>
          <v-subheader class="px-0">Tóm tắt nội dung:</v-subheader>
        </v-flex>
        <v-flex xs12 sm10>
          <v-text-field
            placeholder="Nội dung"
            textarea
            rows="2"
            v-model="content"
          ></v-text-field>
        </v-flex>
    </v-layout>
    
    <v-layout wrap v-else>
      <v-flex xs12 sm2>
        <v-subheader class="px-0">Loại sổ:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4>
        <v-radio-group v-model="register" row @change="registerChange($event)">
          <v-radio label="Tài liệu đi" value="0" ></v-radio>
          <v-radio label="Tài liệu đến" value="1"></v-radio>
        </v-radio-group>
      </v-flex>
       <v-flex xs12 sm2>
        <v-subheader class="pr-0">Số hiệu sổ:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4>
          <v-text-field
          v-model="templateNoTemplate"
        ></v-text-field>
      </v-flex>

      <v-flex xs12 sm2>
        <v-subheader class="px-0">Tiêu đề văn bản:</v-subheader>
      </v-flex>
      <v-flex xs12 sm10>
        <v-text-field
          placeholder="Tiêu đề "
          v-model="subject"
        ></v-text-field>
      </v-flex>

      <v-flex xs12 sm2>
        <v-subheader class="px-0">Số/Ký hiệu:</v-subheader>
      </v-flex>
      <v-flex xs6 sm4 class="layout format_italic_source">
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

      <v-flex xs12 sm2>
        <v-subheader class="pr-0">Loại văn bản:</v-subheader>
      </v-flex>
      <v-flex xs12 sm4>
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

      <v-flex xs12 sm2>
          <v-subheader class="px-0">Tóm tắt nội dung:</v-subheader>
        </v-flex>
        <v-flex xs12 sm10>
          <v-text-field
            placeholder="Nội dung"
            textarea
            rows="2"
            v-model="content"
          ></v-text-field>
        </v-flex>

    </v-layout>
    <uploader :options="optionsForm" :pause_start="pause_start" ref="docfileformupload" class="uploader-example mt-3 text-left" v-if="is_upload == 'true'">
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
    <v-alert outline color="error" icon="warning" :value="apistate=== 2">
      {{messageError}}
    </v-alert>
  </div>
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
      is_template: 'false',
      is_upload: 'false',
      file_attach_api: '/o/v2/mobilink/fileattachs'
    },
    created () {
      var vm = this
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      vm.$nextTick(function () {
        if (vm.template) {
        } else {
          axios.get('/o/v2/mobilink/docfiles?register=0&template=1', config)
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

        axios.get('/o/v2/mobilink/dictcollections/DOCUMENT_TYPE/dictitems?sort=treeIndex', config)
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

        axios.get('/o/v2/mobilink/dictcollections/GOVERMENT_AGENCY/dictitems' + '?level=0', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.issuerCodeItems = serializable.data
          }
        })
        .catch(function (error) {
          console.log(error)
        })

        axios.get('/o/v2/mobilink/workspaces', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.workspaceAddItems = serializable.data
          }
        })
        .catch(function (error) {
          console.log(error)
        })

        axios.get('/o/v2/mobilink/projects' + '?level=0', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.projectNoItems = serializable.data
          }
        })
        .catch(function (error) {
          console.log(error)
        })
        
      })
    },
    data () {
      return {
        seqNumDen: null,
        is_so_den: false,
        optionsForm: {
          target: '//localhost:3000/upload',
          testChunks: true
        },
        optionsForm2: {
          target: '//localhost:3000/upload1232131',
          testChunks: true
        },
        pause_start: true,
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
        projectNoItems: [],
        projectNo: {},
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
        workspaceAdd: 0
      }
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
        
        const config = {
          headers: {
            'groupId': vm.group_id
          }
        }
        var params = new URLSearchParams()
        params.append('documentCat', vm.documentCat.value)
        
        if (vm.is_upload == 'true') {
          params.append('templateNo', vm.templateNo)
        } else {
          params.append('templateNo', vm.templateNoTemplate)
        }
        
        params.append('register', vm.register)
        params.append('seqNum', vm.seqNum)
        params.append('registerDate', vm.registerDate)
        params.append('codeNo', vm.codeNo)
        params.append('codeNotation', vm.codeNotation)
        params.append('subject', vm.subject)
        params.append('issuerCode', vm.issuerCode)
        params.append('promulgationDate', vm.promulgationDate)
        params.append('content', vm.content)
        if (vm.is_upload == 'true') {
          var fileListTemp = vm.$refs['docfileformupload'].fileList
          var filesTemp = vm.$refs['docfileformupload'].files
        } else {
          params.append('isTemplate', 1)
        }
        
        axios.post('/o/v2/mobilink/docfiles',
          params,
          config
        )
        .then(function (response) {
          
          vm.$emit('call-back', response.data.docFileId)

          vm.optionsForm.target = '/o/v2/mobilink/fileattachs/upload/'+vm.class_name+'/'+response.data.docFileId+'/'+vm.group_id

          if (vm.is_upload == 'true') {
            for (var key in fileListTemp) {
              fileListTemp[key].uploader.opts.target = vm.optionsForm.target
            }

            vm.$refs['docfileformupload'].fileList = fileListTemp
            vm.$refs['docfileformupload'].myCustomUpload()

            var paramsApi2 = new URLSearchParams()
            paramsApi2.append('workspaces', JSON.stringify(vm.workspaceAdd))
            paramsApi2.append('className', vm.class_name)
            paramsApi2.append('classPK', response.data.docFileId)
            axios.post('/o/v2/mobilink/resourceworkspaces/update',
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
          }

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
        
      },
      templateNoChange: function (item) {
        var vm = this
        vm.documentCat = item.documentCat
        if (vm.is_so_den) {
          vm.seqNumDen = item.seqNum
        } else {
          vm.seqNum = item.seqNum
          vm.seqNumDen = item.seqNum
        }
        vm.projectNo = item.projectNo
        vm.codeNo = item.codeNo
        vm.codeNotation = item.codeNotation
        vm.subject = item.subject
        vm.signerInfo = item.signerInfo
        vm.issuerCode = item.issuerCode
        try {
          if (item.promulgationDate.length > 0) {
            vm.promulgationDate = vm.customeDateStr(item.promulgationDate)
          }
          if (item.registerDate.length > 0) {
            vm.registerDate = vm.customeDateStr(item.registerDate)
          }
          if (item.dueDate.length > 0) {
            vm.dueDate = vm.customeDateStr(item.dueDate)
          }
        }
        catch(err) {
            console.log(err)
        }
        vm.content = item.content
      },
      registerChange: function (item) {
        var vm = this
        console.log(item)
        console.log(item == 1)
        if (item == 1) {
          vm.is_so_den = true
        } else {
          vm.is_so_den = false
        }
        
        const config = {
          headers: {
            'groupId': vm.group_id
          }
        }
        axios.get('/o/v2/mobilink/docfiles?template=1&register='+item, config)
          .then(function (response) {
            var serializable = response.data
            if (serializable.hasOwnProperty('data')) {
              vm.templateNoItems = serializable.data
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
</style>
