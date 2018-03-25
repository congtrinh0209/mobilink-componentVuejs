<template>
  <v-expansion-panel expand>
    <v-expansion-panel-content v-bind:value="expanded">
      <div slot="header">{{ votingTitle }}</div>
      <v-list class="mobilink--voting">
        <template v-for="(item, index) in votingItems">
          <v-list-tile :key="index">
            <v-list-tile-content>
              <v-list-tile-sub-title class="grey--text text--darken-4">{{index + 1}}. {{ item.subject }}</v-list-tile-sub-title>
              <v-list-tile-sub-title class="text-right">Tạo bởi {{ item.userName }} <small class="text-gray">{{ item.createDate | datetimelog}}</small></v-list-tile-sub-title>
              
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
              </ul>
            </v-list-tile-content>
          </v-list-tile>
          <v-divider v-if="index + 1 < votingItems.length" :key="index"></v-divider>
        </template>
      </v-list>
    </v-expansion-panel-content>
  </v-expansion-panel>
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
    votingTitle: 'Lấy ý kiến thống nhất'
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
      votingItems: [],
      votingSelected: '',
      votingPer: 0
    }
  },
  methods: {
    
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
}
</style>
