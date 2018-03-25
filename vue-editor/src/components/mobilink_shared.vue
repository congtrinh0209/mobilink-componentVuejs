<template>

    <v-layout row style="margin-left: 0;">
    
        <v-flex xs12>

            <v-card>
                <v-card-title>
                    <div class="box-panel shared-w100">
                        <div class="text-primary text-center"><span id="docfile-detail-follow-list-counter">{{ followers.length }}</span> người theo dõi
                            <div class="MT20 mt-3">
                                <ul class="img-followers">
                                    <li v-for="(item, index) in followers" v-bind:key="index" v-if="index < 8">
                                      <v-tooltip top>
                                        <img :src="'/image/user_male_portrait?img_id='+item.portraitId" slot="activator" />
                                        <span>{{ item.fullName }}</span>
                                      </v-tooltip>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </v-card-title>
  
                <v-card-actions class="px-0 py-0">
                    <div class="one-row mx-0 layout">
  
                        <div class="full-width flex xs6 px-0">
                            <button @click.stop.prevent="sharedDialogFunc()" class="shared_btn btn btn-primary image-preview-input btn-block no-border-top btn--block px-0 mx-0"> 
                            <i class="fa fa-share-alt" aria-hidden="true"></i> Chia sẻ 
                        </button>
                    </div>
  
                    <div class="full-width flex xs6 px-0"> 
                        <button @click.stop.prevent="historyDialogFunc()" class="history_btn btn btn-primary image-preview-input btn-block no-border-top no-border-left btn--block px-0 mx-0"> 
                            <i class="fa fa-list-alt" aria-hidden="true"></i> Lịch sử 
                        </button>                        
                    </div>
                  </div>
              </v-card-actions>
  
          </v-card>
      </v-flex>

      
        <v-dialog v-model="sharedDialog" persistent max-width="900" transition="fade-transition">
            <v-card style="min-height: 500px;" :class="{'mobilink-shared-root editable-wrap editable-wrap-before-select': permission !== 'write' && permission !== 'owner'}">
                <v-card-title class="px-0 py-0" style="background-color: rgb(214, 233, 247);min-height: 43px;position: fixed;max-width: 900px;width: 100%;z-index: 9999;">
                    <span class="pl-3">Chia sẻ</span>
                    <v-spacer></v-spacer>
                    
                    <div class="menu" style="display: inline-block;">
                        <div class="menu__activator">
                            <v-btn icon slot="activator" @click.native="sharedDialog = false">
                                <v-icon>close</v-icon>
                            </v-btn>
                        </div>
                    </div>

                </v-card-title>
                <v-card-text style="padding-top: 35px;">
                    
                    <div v-if="permission === 'write' || permission === 'owner'">
                      <v-radio-group @change="sharedVisibilityChangeValue" v-model="sharedVisibility" :input-value="sharedVisibility" :mandatory="false">
                        <v-radio label="Cho mọi người dùng kể cả không có tài khoản" value="0"></v-radio>
                        <v-radio label="Cho người dùng có tài khoản" value="1"></v-radio>
                        <v-radio label="Cho người dùng nằm trong vùng làm việc" value="2"></v-radio>
                      </v-radio-group>
                    </div>
                    <div style="margin-top: 25px;" v-else>
                      <label style="display: block;" v-if="sharedVisibility === '1'">Cho người dùng có tài khoản</label>
                      <label style="display: block;" v-else-if="sharedVisibility === '2'">Cho người dùng nằm trong vùng làm việc</label>
                      <label style="display: block;" v-else>Cho mọi người dùng kể cả không có tài khoản</label>
                    </div>
                    <v-alert outline color="error" icon="warning" :value="apistate1 === 2">
                        Lỗi cập nhật phân quyền văn bản!
                    </v-alert>
                    <v-select
                    return-object
                    label="Chọn danh sách vùng làm việc lưu trữ..."
                    v-bind:items="resourceworkspacesWrite"
                    v-model="resourceworkspaceWrite"
                    item-text="workspaceName"
                    item-value="workspaceId"
                    multiple
                    chips
                    max-height="auto"
                    hide-selected
                    autocomplete
                    @change="resourceworkspaceChangeValue"
                    >
                        <template slot="selection" slot-scope="data">
                            <v-chip
                                close
                                @input="data.parent.selectItem(data.item)"
                                :selected="data.selected"
                                class="chip--select-multi"
                                :key="JSON.stringify(data.item)"
                            >
                                {{ data.item.workspaceName }}
                            </v-chip>
                        </template>
                    </v-select>
                    <v-select
                    return-object
                    label="Chọn danh sách vùng làm việc chia sẻ..."
                    v-bind:items="resourceworkspaces"
                    v-model="resourceworkspace"
                    item-text="workspaceName"
                    item-value="workspaceId"
                    multiple
                    chips
                    max-height="auto"
                    hide-selected
                    autocomplete
                    @change="resourceworkspaceChangeValue"
                    >
                        <template slot="selection" slot-scope="data">
                            <v-chip
                                close
                                @input="data.parent.selectItem(data.item)"
                                :selected="data.selected"
                                class="chip--select-multi"
                                :key="JSON.stringify(data.item)"
                            >
                                {{ data.item.workspaceName }}
                            </v-chip>
                        </template>
                    </v-select>
                    <v-alert outline color="error" icon="warning" :value="apistate2 === 2">
                        Lỗi cập nhật phân quyền vùng làm việc!
                    </v-alert>
                    <v-select
                    return-object
                    label="Chọn danh sách chức vụ..."
                    v-bind:items="resourceroles"
                    v-model="resourcerole"
                    item-text="roleName"
                    item-value="roleId"
                    multiple
                    chips
                    max-height="auto"
                    hide-selected
                    autocomplete
                    @change="resourceroleChangeValue"
                    >
                        <template slot="selection" slot-scope="data">
                            <v-chip
                                close
                                @input="data.parent.selectItem(data.item)"
                                :selected="data.selected"
                                class="chip--select-multi"
                                :key="JSON.stringify(data.item)"
                            >
                                <v-avatar @click.stop.prevent="changePermissionRoleFunc(data.item)" class="green darken-2" style="color: white; cursor: pointer;" v-if="data.item.right === 2"> W </v-avatar>
                                <v-avatar @click.stop.prevent="changePermissionRoleFunc(data.item)" class="accent" style="cursor: pointer;" v-if="data.item.right === 0"> R </v-avatar>
                                {{ data.item.roleName }}
                            </v-chip>
                        </template>
                    </v-select>
                    <v-alert outline color="error" icon="warning" :value="apistate3 === 2">
                        Lỗi cập nhật phân quyền chức vụ!
                    </v-alert>
                    <v-select
                    return-object
                    label="Chọn danh sách người có tài khoản..."
                    v-bind:items="resourceusers"
                    v-model="resourceuser"
                    item-text="fullName"
                    item-value="userId"
                    multiple
                    chips
                    max-height="auto"
                    hide-selected
                    autocomplete
                    @change="resourceuserChangeValue"
                    >
                        <template slot="selection" slot-scope="data">
                            <v-chip
                                close
                                @input="data.parent.selectItem(data.item)"
                                :selected="data.selected"
                                class="chip--select-multi"
                                :key="JSON.stringify(data.item)"
                            >
                                <v-avatar @click.stop.prevent="changePermissionUserFunc(data.item)" class="green darken-2" style="color: white; cursor: pointer;" v-if="data.item.right === 2"> W </v-avatar>
                                <v-avatar @click.stop.prevent="changePermissionUserFunc(data.item)" class="accent" style="cursor: pointer;" v-if="data.item.right === 0"> R </v-avatar>
                                {{ data.item.fullName }}
                            </v-chip>
                        </template>
                    </v-select>
                    <v-alert outline color="error" icon="warning" :value="apistate4 === 2">
                        Lỗi cập nhật phân quyền người có tài khoản!
                    </v-alert>
                    <v-select
                    return-object
                    label="Chọn danh sách người không có tài khoản..."
                    v-bind:items="resourceusersguests"
                    v-model="resourceusersguest"
                    item-text="fullName"
                    item-value="email"
                    multiple
                    chips
                    max-height="auto"
                    hide-selected
                    autocomplete
                    @change="resourceusersguestChangeValue"
                    >
                        <template slot="selection" slot-scope="data">
                            <v-chip
                                close
                                @input="data.parent.selectItem(data.item)"
                                :selected="data.selected"
                                class="chip--select-multi"
                                :key="JSON.stringify(data.item)"
                            >
                                <v-avatar @click.stop.prevent="changePermissionGuestFunc(data.item)" class="green darken-2" style="color: white; cursor: pointer;" v-if="data.item.right === 2"> W </v-avatar>
                                <v-avatar @click.stop.prevent="changePermissionGuestFunc(data.item)" class="accent" style="cursor: pointer;" v-if="data.item.right === 0"> R </v-avatar>
                                {{ data.item.fullName }}
                            </v-chip>
                        </template>
                    </v-select>
                    <v-alert outline color="error" icon="warning" :value="apistate5 === 2">
                        Lỗi cập nhật phân quyền người không có tài khoản!
                    </v-alert>
                    <v-alert outline color="success" icon="check_circle" :value="apistateok">
                      Xác nhận phân quyền thành công!
                    </v-alert>
                </v-card-text>

                <v-card-actions v-if="permission === 'write' || permission === 'owner'">
                    <v-btn block color="primary" v-on:click.native="sharedDialogSubmit()"
                      :loading="sharedDialog_hidden_loading" 
                      :disabled="sharedDialog_hidden_loading"
                    >
                        <v-icon v-if="apistate2 > 0 || apistate3 > 0 || apistate4 > 0 || apistate5 > 0 ">done_all</v-icon>
                        <v-icon v-else>done</v-icon>
                        &nbsp;&nbsp; Xác nhận thay đổi
                    </v-btn>
                </v-card-actions>
                
            </v-card>
        </v-dialog>

        <v-dialog v-model="historyDialog" persistent max-width="900" transition="fade-transition">
            <v-card>
                <v-card-title class="px-0 py-0" style="background-color: rgb(214, 233, 247);min-height: 43px;position: fixed;max-width: 900px;width: 100%;z-index: 9999;">
                    <span class="pl-3">Lịch sử</span>
                    <v-spacer></v-spacer>
                    
                    <div class="menu" style="display: inline-block;">
                        <div class="menu__activator">
                            <v-btn icon slot="activator" @click.native="historyDialog = false">
                                <v-icon>close</v-icon>
                            </v-btn>
                        </div>
                    </div>

                </v-card-title>
                <v-card-text style="padding-top: 60px;">
                  <div v-for="(item, index) in changeLogs" v-bind:key="index">
                    <div class="border-bottom border-color-lightblue PB10 MB10">
                      {{ item.createDate | datetimelog }}
                      <strong class="PL20 PR15"> {{ item.author }} : </strong>
                      <i>{{ item.content }}</i>
                    </div>
                  </div>
                  <v-pagination 
                    class="center--pagging"
                    :length="changeLogsTotal" 
                    v-model="changeLogsPage" 
                    :total-visible="10" 
                    @input="changeLogsPagging()">
                  </v-pagination>
                </v-card-text>
            </v-card>
        </v-dialog>

  </v-layout>

</template>

<script>
import axios from 'axios'
const COMPONENT_NAME = 'jx-mobilink-share'

export default {
  name: COMPONENT_NAME,
  props: {
    class_pk: null,
    class_name: null,
    group_id: null,
    visibilities_api: '',
    resourceworkspace_get_api: null,
    resourceroles_get_api: '',
    resourceusers_get_api: '',
    changelogs_get_api: '',
    permission: 'read'
  },
  data () {
    return {
      apistateok: false,
      apistate1: 1,
      apistate2: 0,
      apistate3: 0,
      apistate4: 0,
      apistate5: 0,
      sharedDialog: false,
      historyDialog: false,
      sharedVisibility: '0',
      resourceworkspace: [],
      resourceworkspaces: [],
      resourceworkspaceWrite: [],
      resourceworkspacesWrite: [],
      resourcerole: [],
      resourceroles: [],
      resourceuser: [],
      resourceusers: [],
      resourceusersguest: [],
      resourceusersguests: [],
      changeLogs: [],
      changeLogsPage: 1,
      changeLogsTotal: 0,
      followers: [],
      sharedDialog_hidden_loading: false
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
      if (vm.resourceusers_get_api != null) {
        console.log(vm.resourceusers_get_api)
        axios.get(vm.resourceusers_get_api + '/' + vm.class_name + '/' + vm.class_pk + '?selected=true&sort=fullName', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.followers = serializable.data
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      }
    })
  },
  methods: {
    _initInvitedUser: function () {
      var vm = this
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      axios.get(vm.resourceusers_get_api + '/' + vm.class_name + '/' + vm.class_pk + '?selected=true&sort=fullName', config)
      .then(function (response) {
        var serializable = response.data
        if (serializable.hasOwnProperty('data')) {
          vm.followers = serializable.data
        }
      })
      .catch(function (error) {
        console.log(error)
      })
    },
    sharedVisibilityChangeValue: function (data) {
      this.apistate1 = 1
    },
    resourceworkspaceChangeValue: function (data) {
      this.apistate2 = 1
      console.log(data)
    },
    resourceroleChangeValue: function (data) {
      this.apistate3 = 1
      console.log(data)
    },
    resourceuserChangeValue: function (data) {
      this.apistate4 = 1
      console.log(data)
    },
    resourceusersguestChangeValue: function (data) {
      this.apistate5 = 1
      console.log(data)
    },
    sharedDialogFunc: function () {
      var vm = this
      vm.sharedDialog = true
      vm.apistateok = false
      vm.apistate1 = 1
      vm.apistate2 = 0
      vm.apistate3 = 0
      vm.apistate4 = 0
      vm.apistate5 = 0
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      if (vm.visibilities_api != null) {
        console.log(vm.visibilities_api)
        axios.get(vm.visibilities_api + '/' + vm.class_name + '/' + vm.class_pk, config)
        .then(function (response) {
          var serializable = response.data
          vm.sharedVisibility = serializable.security + '';
        })
        .catch(function (error) {
          console.log(error)
          if (error.response && error.response.status === 404) {
            
          }
        })
      }
      if (vm.resourceworkspace_get_api != null) {
        console.log(vm.resourceworkspace_get_api)
        vm.resourceworkspace = []
        axios.get(vm.resourceworkspace_get_api + '/' + vm.class_name + '/' + vm.class_pk + '?sort=workspaceName&full=true&permanent=false', config)
        .then(function (response) {
          var serializable = response.data
          vm.resourceworkspaces = serializable.data
          for (var key in vm.resourceworkspaces) {
            if (vm.resourceworkspaces[key].hasOwnProperty('selected') && vm.resourceworkspaces[key]['selected'] === true ) {
              vm.resourceworkspace.push(vm.resourceworkspaces[key])
            }
          }
        })
        .catch(function (error) {
          console.log(error)
        })
        
        vm.resourceworkspaceWrite = []
        axios.get(vm.resourceworkspace_get_api + '/' + vm.class_name + '/' + vm.class_pk + '?sort=workspaceName&full=true&permanent=true', config)
        .then(function (response) {
          var serializable = response.data
          vm.resourceworkspacesWrite = serializable.data
          for (var key in vm.resourceworkspacesWrite) {
            if (vm.resourceworkspacesWrite[key].hasOwnProperty('selected') && vm.resourceworkspacesWrite[key]['selected'] === true ) {
              vm.resourceworkspaceWrite.push(vm.resourceworkspacesWrite[key])
            }
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      }
      if (vm.resourceroles_get_api != null) {
        console.log(vm.resourceroles_get_api)
        vm.resourcerole = []
        axios.get(vm.resourceroles_get_api + '/' + vm.class_name + '/' + vm.class_pk + '?sort=roleName&full=true', config)
        .then(function (response) {
          var serializable = response.data
          vm.resourceroles = serializable.data
          for (var key in vm.resourceroles) {
            if (vm.resourceroles[key].hasOwnProperty('selected') && vm.resourceroles[key]['selected'] === true ) {
              vm.resourcerole.push(vm.resourceroles[key])
            }
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      }
      if (vm.resourceusers_get_api != null) {
        console.log(vm.resourceusers_get_api)
        vm.resourceuser = []
        vm.resourceusersguest = []
        axios.get(vm.resourceusers_get_api + '/' + vm.class_name + '/' + vm.class_pk + '?sort=fullName', config)
        .then(function (response) {
          var serializable = response.data
          vm.resourceusers = serializable.data
          for (var key in vm.resourceusers) {
            if (vm.resourceusers[key].hasOwnProperty('selected') && vm.resourceusers[key]['selected'] === true ) {
              vm.resourceuser.push(vm.resourceusers[key])
            }
          }
        })
        .catch(function (error) {
          console.log(error)
        })
        axios.get(vm.resourceusers_get_api + '/' + vm.class_name + '/' + vm.class_pk + '?full=guest&sort=fullName', config)
        .then(function (response) {
          var serializable = response.data
          vm.resourceusersguests = serializable.data
          for (var key in vm.resourceusersguests) {
            if (vm.resourceusersguests[key].hasOwnProperty('selected') && vm.resourceusersguests[key]['selected'] === true ) {
              vm.resourceusersguest.push(vm.resourceusersguests[key])
            }
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      }
    },
    changePermissionWorkspaceFunc: function (item) {
      console.log(item)
      if (item.right === 2) {
        item.right = 0
      } else {
        item.right = 2
      }
      this.apistate2 = 1
    },
    changePermissionRoleFunc: function (item) {
      console.log(item)
      if (item.right === 2) {
        item.right = 0
      } else {
        item.right = 2
      }
      this.apistate3 = 1
    },
    changePermissionUserFunc: function (item) {
      console.log(item)
      if (item.right === 2) {
        item.right = 0
      } else {
        item.right = 2
      }
      this.apistate4 = 1
    },
    changePermissionGuestFunc: function (item) {
      console.log(item)
      if (item.right === 2) {
        item.right = 0
      } else {
        item.right = 2
      }
      this.apistate5 = 1
    },
    historyDialogFunc: function () {
      var vm = this
      vm._initChangeLogs()
    },
    changeLogsPagging: function () {
      this._initChangeLogs()
    },
    _initChangeLogs: function () {
      var vm = this
      vm.historyDialog = true
      var paramsBuilder = {
        start: vm.changeLogsPage * 15 - 15,
        end: vm.changeLogsPage * 15,
        status: 1
      }
      const config = {
        params: paramsBuilder,
        headers: {
          'groupId': vm.group_id
        }
      }
      if (vm.changelogs_get_api != null) {
        console.log(vm.changelogs_get_api)
        axios.get(vm.changelogs_get_api + '/' + vm.class_name + '/' + vm.class_pk, config)
        .then(function (response) {
          var serializable = response.data
          vm.changeLogs = serializable.data
          vm.changeLogsTotal = Math.ceil(serializable.total / 15)
        })
        .catch(function (error) {
          console.log(error)
        })
      }
    },
    sharedDialogSubmit: function () {
      var vm = this
      var submitAll = []
      vm.sharedDialog_hidden_loading = true
      const config = {
        headers: {
          'groupId': vm.group_id,
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
          'Accept': 'application/json'
        }
      }
      var params = new URLSearchParams()
      params.append('state', vm.sharedVisibility)
      params.append('className', vm.class_name)
      params.append('classPK', vm.class_pk)
      submitAll.push(
        axios.put(vm.visibilities_api + '/' + vm.class_name + '/' + vm.class_pk,
          params,
          config
        )
        .then(function (response) {
          vm.apistate1 = 1
        })
        .catch(function (error) {
          console.log(error)
          vm.apistate1 = 2
        })
      )
      if (vm.apistate2 > 0) {
        console.log(JSON.stringify(vm.resourceworkspaces))
        var paramsApi2 = new URLSearchParams()
        paramsApi2.append('workspaces', JSON.stringify(vm.resourceworkspace))
        paramsApi2.append('className', vm.class_name)
        paramsApi2.append('classPK', vm.class_pk)
        submitAll.push(
          axios.post(vm.resourceworkspace_get_api + '/update',
            paramsApi2,
            config
          )
          .then(function (response) {
            vm.apistate2 = 0
          })
          .catch(function (error) {
            console.log(error)
            vm.apistate2 = 2
          })
        )
        var paramsApi2Write = new URLSearchParams()
        paramsApi2Write.append('workspaces', JSON.stringify(vm.resourceworkspaceWrite))
        paramsApi2Write.append('className', vm.class_name)
        paramsApi2Write.append('classPK', vm.class_pk)
        submitAll.push(
          axios.post(vm.resourceworkspace_get_api + '/update',
            paramsApi2Write,
            config
          )
          .then(function (response) {
            vm.apistate2 = 0
          })
          .catch(function (error) {
            console.log(error)
            vm.apistate2 = 2
          })
        )
      }
      if (vm.apistate3 > 0) {
        console.log(JSON.stringify(vm.resourceroles_get_api))
        var paramsApi3 = new URLSearchParams()
        paramsApi3.append('roles', JSON.stringify(vm.resourcerole))
        paramsApi3.append('className', vm.class_name)
        paramsApi3.append('classPK', vm.class_pk)
        submitAll.push(
          axios.post(vm.resourceroles_get_api + '/update',
            paramsApi3,
            config
          )
          .then(function (response) {
            vm.apistate3 = 0
          })
          .catch(function (error) {
            console.log(error)
            vm.apistate3 = 2
          })
        )
      }
      if (vm.apistate4 > 0) {
        console.log(JSON.stringify(vm.resourceusers_get_api))
        var paramsApi4 = new URLSearchParams()
        paramsApi4.append('users', JSON.stringify(vm.resourceuser))
        paramsApi4.append('className', vm.class_name)
        paramsApi4.append('classPK', vm.class_pk)
        submitAll.push(
          axios.post(vm.resourceusers_get_api + '/update',
            paramsApi4,
            config
          )
          .then(function (response) {
            vm.apistate4 = 0
            vm._initInvitedUser()
          })
          .catch(function (error) {
            console.log(error)
            vm.apistate4 = 2
          })
        )
      }
      if (vm.apistate5 > 0) {
        console.log(JSON.stringify(vm.resourceusers_get_api))
        var paramsApi5 = new URLSearchParams()
        paramsApi5.append('users', JSON.stringify(vm.resourceusersguest))
        paramsApi5.append('className', vm.class_name)
        paramsApi5.append('classPK', vm.class_pk)
        submitAll.push(
          axios.post(vm.resourceusers_get_api + '/update',
            paramsApi5,
            config
          )
          .then(function (response) {
            vm.apistate5 = 0
            vm._initInvitedUser()
          })
          .catch(function (error) {
            console.log(error)
            vm.apistate5 = 2
          })
        )
      }
      axios.all(submitAll)
        .then(axios.spread(function (apiRespones1, apiRespones2, apiRespones3, apiRespones4, apiRespones5) {
          if (vm.apistate1 === 1 && vm.apistate2 !== 2 && vm.apistate3 !== 2 && vm.apistate4 !== 2 && vm.apistate5 !== 2) {
            vm.apistateok = true
            setTimeout(
              function(){ 
                vm.apistateok = false
                vm.apistate1 = 1
                vm.apistate2 = 0
                vm.apistate3 = 0
                vm.apistate4 = 0
                vm.apistate5 = 0
              }, 
            3000)
          }
          vm.sharedDialog_hidden_loading = false
          return Promise.reject()
        }))
        .catch(function (error) {
          console.log(error)
          vm.sharedDialog_hidden_loading = false
        })
    }
  }
}
</script>

<style>
/*----- Row Images Followers -----*/
.img-followers {
  margin-left: -10px;
  display: inline-flex;
  display: -webkit-inline-flex;
  list-style: none;
}
.img-followers li img {
  float: left;
  border-radius: 50%;
  border: 2px solid white;
  width: 40px;
  height: 40px;
  margin-right: -10px;
}
.shared-w100 {
  width: 100%;
  text-align: center;
}
.shared_btn {
  border-right: 1px solid #e1e2e1;
  box-shadow: none !important;
  border-top: 1px solid #e1e2e1;
}
.history_btn {
  box-shadow: none !important;
  border-top: 1px solid #e1e2e1;
}
.card.no-shadow {
  box-shadow: none;
  border: 1px solid #e1e2e1;
}
.border-color-lightblue {
  border-color: #dae9f4;
}

.border-bottom {
  border-bottom: 1px solid #e3e3e3;
}

.PB10 {
  padding-bottom: 10px !important;
}

.MB10 {
  margin-bottom: 10px !important;
}

.PL20 {
  padding-left: 20px !important;
}

.PR15 {
  padding-right: 15px !important;
}

.center--pagging {
  display: -webkit-box;
  display: flex;
  -webkit-flex-wrap: wrap;
  flex-wrap: wrap;
  -webkit-justify-content: center;
  justify-content: center;
}
.mobilink-shared-root.editable-wrap.editable-wrap-before-select .input-group--chips label{
      display: block;
}
.mobilink-shared-root.editable-wrap.editable-wrap-before-select .input-group {
      padding-top: 20px;
}
</style>
