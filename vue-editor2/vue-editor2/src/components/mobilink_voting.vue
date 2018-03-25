<template>
  <div style="position: relative;">
  <v-expansion-panel expand>
    <v-expansion-panel-content v-bind:value="expanded">
      <div slot="header">{{ votingTitle }}</div>
      <v-list class="mobilink--voting">
        <template v-for="(item, index) in votingItems">
          <v-list-tile :key="index">
            <v-list-tile-content>
              <v-list-tile-sub-title class="grey--text text--darken-4 px-4">{{index + 1}}. {{ item.subject }}</v-list-tile-sub-title>
              <v-list-tile-sub-title class="text-right">
                Tạo bởi {{ item.userName }} <small class="text-gray">{{ item.createDate | datetimelog}}</small>
                <v-btn v-if="permission === 'write' || permission === 'owner'" v-on:click.native="votingEdit(item, index)" flat icon class="py-0 px-0 mx-0 my-0 btn--edit--icon"><v-icon>edit</v-icon></v-btn>
                <v-btn v-if="permission === 'write' || permission === 'owner'" v-on:click.native="votingRemove(item, index)" flat icon class="py-0 px-0 mx-0 my-0 btn--clear--icon" ><v-icon color="red darken-3">clear</v-icon></v-btn>
              </v-list-tile-sub-title>
              
              <ul class="voting_results">
                <v-radio-group v-model="item.selected">
                <li v-for="(itemChilds, indexResults) in item.choices" v-bind:key="indexResults">
                  <div status="success" class="voting-results-wrap">
                    <div v-if="item.answersCount > 0 && item.answers[indexResults]" class="uploader-file-progress" :style="'background: white;transform: translateX(' + (item.answers[indexResults] / item.answersCount)*100 + '%);'"></div>
                    <div v-else class="uploader-file-progress" :style="'background: white;transform: translateX(0%);'"></div>
                    <div class="uploader-file-info">
                      <div class="voting-processing">
                        <v-radio 
                          :label="itemChilds"
                          color="primary"
                          :value="indexResults + 1"></v-radio>
                      </div>
                      <div class="voting_result_summer">{{item.answers[indexResults]}} / {{item.answersCount}}</div>
                    </div>
                  </div>
                </li>
                </v-radio-group>
                <div class="pl-4 pr-3">
                  <v-text-field v-if="item.commentable"
                    v-model="item.comment"
                    placeholder="Nhập đáp án khác ..."
                    textarea
                    rows="2"
                  ></v-text-field>
                </div>
              </ul>
            </v-list-tile-content>
          </v-list-tile>
          <v-divider v-if="index + 1 < votingItems.length" :key="index"></v-divider>
        </template>
        <v-btn flat block @click.native="doVottingResultSubmit" v-if="votingItems.length > 0"
          :loading="votingDialog_hidden_loading" 
          :disabled="votingDialog_hidden_loading"
        >
          Gửi ý kiến &nbsp;&nbsp;
          <v-icon>send</v-icon>
        </v-btn>
      </v-list>
    </v-expansion-panel-content>
  </v-expansion-panel>
  <v-dialog v-model="votingDialog" persistent max-width="900" transition="fade-transition">
    <v-card :class="{'mobilink-shared-root editable-wrap editable-wrap-before-select': permission !== 'write' && permission !== 'owner'}">
        <v-card-title class="px-0 py-0" style="background-color: rgb(214, 233, 247);min-height: 43px;position: fixed;max-width: 900px;width: 100%;z-index: 9999;">
            <span class="pl-3">Thêm nội dung lấy ý kiến</span>
            <v-spacer></v-spacer>
            
            <div class="menu" style="display: inline-block;">
                <div class="menu__activator">
                    <v-btn icon slot="activator" @click.native="votingDialog = false">
                        <v-icon>close</v-icon>
                    </v-btn>
                </div>
            </div>

        </v-card-title>
        <v-card-text class="voting__add" style="padding-top: 65px;">
          <v-layout wrap>
            <v-flex xs12 class="mb-2">
              <v-text-field
                label="nhập dung xin ý kiến"
                placeholder="nhập dung xin ý kiến"
                textarea
                rows="2"
                v-model="subject"
              ></v-text-field>
            </v-flex>
            <v-flex xs12>
              <v-text-field
                label="Câu trả lời"
                placeholder="nhập câu trả lời phân tách xuống dòng"
                textarea
                rows="3"
                v-model="choices"
              ></v-text-field>
            </v-flex>
            <v-flex xs12 class="votting__no_padding">
              <v-checkbox label="Sử dụng câu trả lời khác" v-model="commentable" light></v-checkbox>
            </v-flex>
          </v-layout>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn flat="flat" @click.native="votingDialog = false"><v-icon>close</v-icon>&nbsp;Quay lại </v-btn>
          <v-btn flat="flat" @click.native="doVottingSubmit" 
            v-if="(permission === 'write' || permission === 'owner') && votingId === 0"
            :loading="votingDialog_hidden_loading" 
            :disabled="votingDialog_hidden_loading"
          ><v-icon>save</v-icon>&nbsp;Ghi lại </v-btn>
          <v-btn flat="flat" @click.native="doVottingEditSubmit" 
            v-if="(permission === 'write' || permission === 'owner') && votingId > 0"
            :loading="votingDialog_hidden_loading" 
            :disabled="votingDialog_hidden_loading"
          ><v-icon>save</v-icon>&nbsp;Ghi lại </v-btn>
        </v-card-actions>

      </v-card>
  </v-dialog>
  <v-btn flat icon class="expansion__plus__btn" value="1" v-if="permission === 'write' || permission === 'owner'" v-on:click.native="votingDialog = !votingDialog" >
    <v-icon>add_circle</v-icon>
  </v-btn>
  </div>
</template>

<script>
import axios from 'axios'
const COMPONENT_NAME = 'jx-mobilink-voting'

export default {
  name: COMPONENT_NAME,
  props: {
    id: null,
    class_pk: null,
    class_name: null,
    group_id: null,
    profilePictureURL: 'https://viima-app.s3.amazonaws.com/media/user_profiles/user-icon.png',
    votingTitle: 'Thông tin xử lý',
    voting_api: '',
    expanded: true,
    votingTitle: 'Lấy ý kiến thống nhất',
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
      axios.get(vm.voting_api + '/' + vm.class_name + '/' + vm.class_pk + '?sort=createDate', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.votingItems = serializable.data
          }
        })
        .catch(function (error) {
          console.log(error)
        })
    })
  },
  data () {
    return {
      subject: '',
      choices: '',
      commentable: false,
      votingItems: [],
      votingSelected: '',
      votingPer: 0,
      votingDialog: false,
      votingDialog_hidden_loading: false,
      votingId: 0
    }
  },
  methods: {
    _initVotingList: function () {
      var vm = this
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      axios.get(vm.voting_api + '/' + vm.class_name + '/' + vm.class_pk + '?sort=createDate', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.votingItems = serializable.data
          }
        })
        .catch(function (error) {
          console.log(error)
        })
    },
    doVottingResultSubmit: function () {
      var vm = this
      vm.votingDialog_hidden_loading = true
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }

      for (var key in vm.votingItems) {
        var params = new URLSearchParams()
        params.append('comment', '')
        params.append('selected', vm.votingItems[key].selected)
        params.append('email', '')
        params.append('fullName', themeDisplay.getUserName())
        axios.post(vm.voting_api +'/'+vm.votingItems[key].votingId+'/results',
          params,
          config
        )
        .then(function (response) {
          vm.votingDialog_hidden_loading = false
          vm._initVotingList()
        })
        .catch(function (error) {
          console.log(error)
          vm.votingDialog_hidden_loading = false
        })
      }
    },
    doVottingSubmit: function () {
      var vm = this
      vm.votingDialog_hidden_loading = true
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      var params = new URLSearchParams()
      params.append('className', vm.class_name)
      params.append('classPK', vm.class_pk)
      params.append('subject', vm.subject)
      params.append('choices', vm.choices)
      params.append('commentable', vm.commentable)

      axios.post(vm.voting_api,
        params,
        config
      )
      .then(function (response) {
        vm._initVotingList()
        vm.votingDialog_hidden_loading = false
        vm.votingDialog = false
        vm.subject = ''
        vm.choices = ''
        vm.commentable = false
      })
      .catch(function (error) {
        console.log(error)
        vm.votingDialog_hidden_loading = false
      })
    },
    doVottingEditSubmit: function () {
      var vm = this
      vm.votingDialog_hidden_loading = true
      const config = {
        headers: {
          'groupId': vm.group_id
        }
      }
      var params = new URLSearchParams()
      params.append('className', vm.class_name)
      params.append('classPK', vm.class_pk)
      params.append('subject', vm.subject)
      params.append('choices', vm.choices)
      params.append('commentable', vm.commentable)

      axios.put(vm.voting_api + '/' + vm.votingId,
        params,
        config
      )
      .then(function (response) {
        vm._initVotingList()
        vm.votingDialog_hidden_loading = false
        vm.votingDialog = false
        vm.subject = ''
        vm.choices = ''
        vm.commentable = false
      })
      .catch(function (error) {
        console.log(error)
        vm.votingDialog_hidden_loading = false
      })
    },
    votingEdit: function (item, index) {
      console.log(item)
      this.votingDialog = true
      this.votingId = item.votingId
      this.subject = item.subject
      for (var key in item.choices) {
        this.choices +=  item.choices[key] + '\r\n'
      }
      console.log(this.choices)
      this.commentable = item.commentable
    },
    votingRemove: function (item, index) {
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
        axios.delete(vm.voting_api + '/' + item.votingId, config).then(function (response) {
          vm.votingItems.splice(index, 1)
        })
        .catch(function (error) {
          console.log(error)
        })
        dialog.close()
      })
      .catch((e) => {
        console.log(e)
      })
    }
  }
}
</script>

<style>
.mobilink--voting .list__tile {
  height: auto;
}
.mobilink--voting .voting_results {
  width: 100%;
}
.mobilink--voting .voting_results .input-group__details{
  min-height: 2px;
}
.mobilink--voting .voting_results li {
  position: relative;
  margin-bottom: 2px;
  display: block;
}
.uploader-file-progress {
  position: absolute;
  width: 100%;
  height: 100%;
  background: #e2eeff;
  -webkit-transform: translateX(-100%);
  transform: translateX(-100%);
}
.mobilink--voting hr.divider{
  margin-bottom: 15px;
}
.mobilink--voting .voting_result_summer {
  width: 20%;
  text-align: right;
  padding-right: 15px;
  position: absolute;
  right: 0;
  top: 8px;
}
.mobilink--voting .voting-results-wrap {
  background: rgb(226, 238, 255);
}
.mobilink--voting .voting-processing {
  width: 80%;
}
.mobilink--voting .uploader-file-info {
  padding: 8px;
  padding-left: 20px;
}
.voting__add .input-group--text-field.input-group--textarea:not(.input-group--full-width) label{
    top: 0px !important;
    left: 0px !important;
    transform: translate(0, -8px) scale(1) !important;
}
.votting__no_padding label {
  padding-left: 0px;
}
.mobilink--voting .btn .icon{
	font-size: 17px;
}
.mobilink--voting .btn--block .btn__content {
      justify-content: left !important;
}
.mobilink--voting > li .list__tile{
  padding: 0;
}
.mobilink--voting .voting_results > .radio-group{
  padding: 0;
}
</style>
