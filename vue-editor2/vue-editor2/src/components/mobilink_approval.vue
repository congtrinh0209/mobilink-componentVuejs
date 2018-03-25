<template>
  <div style="position: relative;">
  <v-expansion-panel expand>
    <v-expansion-panel-content v-bind:value="expanded">
      <div slot="header">Phê duyệt văn bản</div>
      <v-card class="card--approval">
        <v-card-text class="px-0 pb-0">
          <v-alert outline color="error" class="mx-3" icon="warning" :value="apistateapproval === 2">
            {{approvalMessage}}
          </v-alert>
          <v-alert outline color="success" class="mx-3" icon="check_circle" :value="apistateapproval === 1">
            {{approvalMessage}}
          </v-alert>
          <div v-for="(item, index) in approvalListItems" v-bind:key="index" class="mb-4">
            <div class="list__tile">
              <div class="avatar list__tile__avatar" style="height: 48px;width: 48px;"><img :src="'/image/user_male_portrait?img_id='+item.portraitId"></div>
              <div class="list__tile__content">
                <strong>{{item.userName}}</strong>
                <div class="text-xs-center" v-if="approvalEditableIndex !== index">
                  {{item.subject}}
                </div>
                <small class="text-gray" v-if="approvalEditableIndex !== index">{{item.modifiedDate | datetimelog}}</small>
                <div v-if="approvalEditableIndex === index" class="card--approval--process" style="margin-left: 0 !important;width: 100%;">
                  <v-select
                    v-bind:items="approvalUserItems"
                    v-model="approvaltoUser"
                    item-text="fullName"
                    item-value="employeeId"
                    label="Người phê duyệt văn bản"
                    autocomplete
                    return-object
                    hide-selected
                  ></v-select>
                  <br/>
                  <v-text-field
                    v-model="approvalsubject"
                    placeholder="Nhập ý kiến ..."
                    textarea
                    rows="2"
                  ></v-text-field>
                  <v-btn-toggle>
                    <v-btn flat v-on:click.native="approvalEditSubmit(item, index)"
                      :loading="approval_hidden_loading" 
                      :disabled="approval_hidden_loading">
                      <span>Lưu thông tin</span>
                      <v-icon>done</v-icon>
                    </v-btn>
                    <v-btn flat v-on:click.native="approvalEditableIndex = -1">
                      <span>Quay lại</span>
                      <v-icon>undo</v-icon>
                    </v-btn>
                  </v-btn-toggle>
                </div>
                <v-btn v-on:click.native="approvalEdit(item, index)" flat icon class="py-0 px-0 mx-0 my-0 btn--edit--icon"><v-icon>edit</v-icon></v-btn>
                <v-btn flat icon class="py-0 px-0 mx-0 my-0 btn--clear--icon" v-on:click.native="approvalRemove(item, index)" ><v-icon color="red darken-3">clear</v-icon></v-btn>
              </div>
            </div>
            <hr class="divider divider--inset">
            <div class="list__tile card--approval--process" v-if="approvalEditableIndex !== index">
              <div class="avatar list__tile__avatar" style="height: 48px;width: 48px;"><img :src="'/image/user_male_portrait?img_id='+item.portraitId"></div>
              <div class="list__tile__content">
                <strong>{{item.toUserName}}</strong>
                <div class="text-xs-center">
                  {{item.approvalNote}}
                  <v-chip v-if="item.state === 0" color="amber darken-1">Chờ phê duyệt</v-chip>
                  <v-chip v-if="item.state === 1" color="teal" text-color="white">
                    <v-avatar>
                      <v-icon>check_circle</v-icon>
                    </v-avatar>
                    Đã phê duyệt
                  </v-chip>
                  <v-chip v-if="item.state === 2" color="red" text-color="white">
                  <v-avatar>
                      <v-icon>clear</v-icon>
                    </v-avatar>
                    Đã từ chối
                  </v-chip>
                </div>
                <v-text-field v-if="approval_user_id == item.toUserId"
                  v-model="aprrovalNote"
                  placeholder="Nhập ý kiến ..."
                  textarea
                  rows="2"
                ></v-text-field>
                <v-btn-toggle v-model="item.state" v-if="approval_user_id == item.toUserId">
                  <v-btn flat value="1" v-on:click.native="approvalStageSubmit(item, index, 1)">
                    <span>Phê duyệt</span>
                    <v-icon>done</v-icon>
                  </v-btn>
                  <v-btn flat value="2" v-on:click.native="approvalStageSubmit(item, index, 2)">
                    <span>Từ chối</span>
                    <v-icon>undo</v-icon>
                  </v-btn>
                </v-btn-toggle>
              </div>
            </div>
          </div>
        </v-card-text>
      </v-card>
      <v-card class="card--approval--add mb-0">
        <v-card-text class="pt-0 pb-2">
          <div v-if="approvaladd" class="card__title px-0 py-0 row" style="background-color: rgb(214, 233, 247); min-height: 43px;"><span class="pl-3">Thêm nội dung trình phê duyệt</span></div>
          <div v-if="approvaladd" class="card--approval--process mt-2" style="margin-left: 0 !important;">
            <v-select
              v-bind:items="approvalUserItems"
              v-model="approvaltoUser"
              item-text="fullName"
              item-value="employeeId"
              label="Người phê duyệt văn bản"
              autocomplete
              return-object
              hide-selected
            ></v-select>
            <br/>
            <v-text-field
              v-model="approvalsubject"
              placeholder="Nhập ý kiến ..."
              textarea
              rows="2"
            ></v-text-field>
          </div>
          <v-btn-toggle>
            <div v-if="approvaladd">
              <v-btn flat v-on:click.native="approvalSubmit()"
                  :loading="approval_hidden_loading" 
                  :disabled="approval_hidden_loading">
                <span>Lưu thông tin</span>
                <v-icon>done</v-icon>
              </v-btn>
              <v-btn flat v-on:click.native="approvaladd = !approvaladd">
                <span>Quay lại</span>
                <v-icon>undo</v-icon>
              </v-btn>
            </div>
          </v-btn-toggle>
        </v-card-text>
      </v-card>
    </v-expansion-panel-content>
  </v-expansion-panel>
  <v-btn flat icon class="expansion__plus__btn" value="1" v-if="!approvaladd && (permission === 'write' || permission === 'owner')" v-on:click.native="approvaladd = !approvaladd">
    <v-icon>add_circle</v-icon>
  </v-btn>
  </div>
</template>

<script>
const COMPONENT_NAME = 'jx-mobilink-approval'

export default {
  name: COMPONENT_NAME,
  props: {
    id: null,
    class_pk: null,
    class_name: null,
    group_id: null,
    profilePictureURL: 'https://viima-app.s3.amazonaws.com/media/user_profiles/user-icon.png',
    expanded: true,
    approvalstate: '0',
    approvaladd: false,
    approval_get_api: '',
    employee_get_api: '',
    approval_user_id: 0,
    permission: 'read'
  },
  created () {
    var vm = this
    const config = {
      headers: {
        'groupId': vm.group_id
      }
    }
    vm.$nextTick(function () {
      if (vm.approval_get_api != null) {
        console.log(vm.approval_get_api)
        axios.get(vm.approval_get_api + '/' + vm.class_name + '/' + vm.class_pk, config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.approvalListItems = serializable.data
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      }
      if (vm.employee_get_api != null) {
        console.log(vm.employee_get_api)
        axios.get(vm.employee_get_api + '?active=true', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.approvalUserItems = serializable.data
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      }
    })
  },
  data () {
    return {
      approvalListItems: [],
      approvalUserItems: [],
      approvalEditableIndex: -1,
      approval_hidden_loading: false,
      apistateapproval: 0,
      approvalMessage: 'Yêu cầu của bạn được thực hiện thành công!',
      approvaltoUser: {},
      approvalsubject: '',
      aprrovalNote: ''
    }
  },
  methods: {
    approvalEdit: function (item, index) {
      var vm = this
      vm.approvaltoUser = {}
      vm.approvalEditableIndex = index
      vm.approvalsubject = item.subject
      if (item.toUserId > 0) {
        var lookup = {};
        for (var i = 0, len = vm.approvalUserItems.length; i < len; i++) {
          console.log(vm.approvalUserItems[i])
          console.log((vm.approvalUserItems[i].mappingUser.userId == item.toUserId))
          if (vm.approvalUserItems[i].mappingUser.userId == item.toUserId) {
            vm.approvaltoUser = vm.approvalUserItems[i]
          }
        }
      }

    },
    approvalRemove: function (item, index) {
      var vm = this
      vm.$dialog.confirm('Bạn có muốn xóa nội dung này!', {
        html: true,
        loader: true,
        okText: 'Xác nhận',
        cancelText: 'Quay lại',
        animation: 'fade'
      })
      .then((dialog) => {
        const config = {
          headers: {
            'groupId': vm.group_id
          }
        }
        axios.delete(vm.approval_get_api + '/' + item.approvalId, config).then(function (response) {
          vm.approvalListItems.splice(index, 1)
          vm.apistateapproval = 1
          vm.approvalMessage = 'Xoá nội dung thành công!'
          setTimeout(
            function(){ 
              vm.apistateapproval = 0
            }, 
          3000)
        })
        .catch(function (error) {
          console.log(error)
          vm.apistateapproval = 2
          vm.approvalMessage = 'Xoá nội dung thất bại!'
          setTimeout(
            function(){ 
              vm.apistateapproval = 0
            }, 
          3000)
        })
        dialog.close()
      })
      .catch((e) => {
        console.log(e)
      })
    },
    approvalSubmit: function () {
      var vm = this
      vm.approval_hidden_loading = true
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      var params = new URLSearchParams()
      params.append('className', vm.class_name)
      params.append('classPK', vm.class_pk)
      params.append('subject', vm.approvalsubject)
      params.append('toUserId', vm.approvaltoUser.mappingUser.userId)
      axios.post(vm.approval_get_api,
        params,
        config
      )
      .then(function (response) {
        vm.approval_hidden_loading = false
        vm.approvalListItems.push(response.data)
        vm.approvaladd = false
        vm.apistateapproval = 1
        vm.approvalMessage = 'Thêm nội dung thành công!'
        setTimeout(
          function(){ 
            vm.apistateapproval = 0
          }, 
        3000)
      })
      .catch(function (error) {
        console.log(error)
        vm.approval_hidden_loading = false
        vm.approvaladd = false
        vm.apistateapproval = 2
        vm.approvalMessage = 'Thêm nội dung thất bại!'
        setTimeout(
          function(){ 
            vm.apistateapproval = 0
          }, 
        3000)
      })
    },
    approvalEditSubmit: function (item, index) {
      var vm = this
      vm.approval_hidden_loading = true
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      var params = new URLSearchParams()
      params.append('className', vm.class_name)
      params.append('classPK', vm.class_pk)
      params.append('subject', vm.approvalsubject)
      params.append('toUserId', vm.approvaltoUser.mappingUser.userId)
      axios.put(vm.approval_get_api + '/' + item.approvalId,
        params,
        config
      )
      .then(function (response) {
        vm.approval_hidden_loading = false
        vm.approvalListItems[index] = response.data
        vm.approvalEditableIndex = -1
        vm.apistateapproval = 1
        vm.approvalMessage = 'Thay đổi nội dung thành công!'
        setTimeout(
          function(){ 
            vm.apistateapproval = 0
          }, 
        3000)
      })
      .catch(function (error) {
        console.log(error)
        vm.approval_hidden_loading = false
        vm.approvalEditableIndex = -1
        vm.apistateapproval = 2
        vm.approvalMessage = 'Thay đổi nội dung thất bại!'
        setTimeout(
          function(){ 
            vm.apistateapproval = 0
          }, 
        3000)
      })
    },
    approvalStageSubmit: function (item, index, stage) {
      var vm = this
      vm.approval_hidden_loading = true
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      var params = new URLSearchParams()
      params.append('state', stage)
      params.append('approvalNote', vm.aprrovalNote)
      axios.put(vm.approval_get_api + '/' + item.approvalId + '/approve',
        params,
        config
      )
      .then(function (response) {
        vm.approval_hidden_loading = false
        vm.approvalListItems[index] = response.data
        vm.apistateapproval = 1
        vm.approvalMessage = 'Thay đổi nội dung thành công!'
        setTimeout(
          function(){ 
            vm.apistateapproval = 0
          }, 
        3000)
      })
      .catch(function (error) {
        console.log(error)
        vm.approval_hidden_loading = false
        vm.apistateapproval = 2
        vm.approvalMessage = 'Thay đổi nội dung thất bại!'
        setTimeout(
          function(){ 
            vm.apistateapproval = 0
          }, 
        3000)
      })
    }
  }
}
</script>

<style>
.card--approval .list__tile{
  height: auto;
}
.card--approval--process {
  margin-left: 50px;
}
.card--approval p{
    margin: 0;
}
.card--approval .divider {
    margin-bottom: 10px;
}
.card--approval--process .input-group--text-field{
    padding: 0;
}
.card--approval--process .input-group--text-field .input-group__input {
    padding-top: 10px !important;
}
.card--approval .avatar img {
    position: absolute; 
    top: 0;
}
.card--approval--process .input-group__details{
    min-height: 1px;
}
.theme--light .card--approval--process .input-group.input-group--textarea:not(.input-group--full-width) .input-group__input {
  border: 1px solid rgba(0,0,0,.54);
}
.card--approval--process .btn-toggle--selected .btn--active{
    color: white;
    background-color: rgb(13, 36, 52) !important;
}
.card--approval--process .input-group--text-field label {
  top: 10px;
}
.card--approval .btn--flat.btn--icon {
    position: absolute !important;
    right: 48px;
    top: 0px;
}
.card--approval .btn--flat.btn--icon i{
    font-size: 17px !important;
}
.card--approval .btn--flat.btn--clear--icon {
    right: 18px;
}
</style>
