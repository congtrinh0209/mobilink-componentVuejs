<template>

    <div id="activity_eventsource">
        
        <v-snackbar :timeout="3000" :top="true" :bottom="false" 
            :right="true" :left="false" :multi-line="true" 
            :vertical="false" v-model="snackbarSucc" class="snackbar-success" > 
            <v-icon flat color="white">check_circle</v-icon> 
                {{alertMess}}
            <v-btn flat fab mini color="white" @click.native="snackbarSucc = false">Tắt</v-btn> 
        </v-snackbar>
        <v-snackbar :timeout="3000" :top="true" :bottom="false" 
            :right="true" :left="false" :multi-line="true" 
            :vertical="false" v-model="snackbarErr" class="snackbar-error" > 
            <v-icon flat color="white">check_circle</v-icon> 
                {{alertMess}}
            <v-btn flat fab mini color="white" @click.native="snackbarErr = false">Tắt</v-btn> 
        </v-snackbar>
        
        <v-dialog class="application theme--light progessLoading" v-model="dialog_loading" persistent max-width="50px">
            <v-card style="text-align: center;padding-top: 5px;">
                <v-progress-circular v-bind:size="25" indeterminate color="primary"></v-progress-circular>
            </v-card>
                
        </v-dialog>

        <div style="position: relative; overflow: hidden;">

            <v-expansion-panel expand class="sub-panel">
                <v-expansion-panel-content value="true">
                    <div slot="header" class="custome-panel-heading-with-icon pl-0 mr-2">
                        <div class="">Cuộc họp liên quan</div>

                        <v-icon class="btn-add mx-0 my-0" v-on:click.stop="show_add_link" 
                        v-if="managerPermision(permission_prop)" grey darken-4>
                            add_circle
                        </v-icon>
                        <!-- <div class="menu" style="display: inline-block;">
                            <div class="menu__activator">
                                <v-btn icon slot="activator" @click.native="fileVersionDialog = false">
                                    <v-icon>close</v-icon>
                                </v-btn>
                            </div>
                        </div> -->
                    </div>
                    
                    <v-card>
                        <v-card-text class="px-0 py-0 pl-2 pr-1">
                            <v-layout row wrap class="mx-0">
                                <!-- Phần dialog -->
                                <v-dialog v-model="dialog_add_eventlink" scrollable persistent max-width="700px">
                                    <v-card>
                                        <v-card-title style="background-color: rgb(214, 233, 247)">
                                            <span>Cập nhật cuộc họp nguồn</span>
                                            <v-spacer></v-spacer>
                                            
                                            <div class="menu" style="display: inline-block;">
                                                <div class="menu__activator">
                                                    <v-btn icon slot="activator">
                                                        <v-icon>clear</v-icon>
                                                    </v-btn>
                                                </div>
                                            </div>
                                        </v-card-title>

                                        <v-card-text>
                                            <v-flex xs12 sm1>
                                                <v-subheader class="px-0">Ngày bắt đầu: </v-subheader>
                                            </v-flex>
                                            <v-flex xs12 sm2 class="mr-3">
                                                <date-picker @change="changeDate" class="mt-2" v-model="timeStart" 
                                                v-bind:not-after="timeStartMax" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
                                            </v-flex>

                                            <v-flex xs12 sm2>
                                                <date-picker @change="changeDate" class="mt-2" v-model="timeEnd" 
                                                v-bind:not-before="timeEndMin" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
                                            </v-flex>
                                        </v-card-text>

                                        <v-card-actions>
                                            <v-spacer></v-spacer>
                                            <v-btn class="mr-3" color="primary"  @click.native="dialog_add_eventlink= false">Hủy</v-btn>
                                            <v-btn color="primary" @click.native="submitAddContact" >Thêm vào liên lạc</v-btn>
                                        </v-card-actions>
                                    </v-card>
                                </v-dialog>
                                <!-- end -->

                                <v-flex xs12 sm12>
                                    <v-card>
                                        
                                        <v-list class="py-0">
                                            <v-list-group class="listGroup py-0" v-for="(item,index) in itemEventLink" 
                                             v-bind:key="item.eventItem.activityId">                                            
                                                <v-list-tile slot="item" class="px-0">
                                                    <v-list-tile-content>
                                                        <v-list-tile-title>
                                                            <v-flex xs12 class="layout wrap">

                                                                <v-flex xs6 sm6 class="pr-2 subEl">
                                                                    
                                                                    <a href="javascript:;" :title="item.eventItem.subject" v-on:click="activityDetail(item.eventItem,index)">
                                                                        {{item.eventItem.subject}}
                                                                    </a>
                                                                </v-flex>
                                                                
                                                                <v-flex xs3 sm3 class="pl-2">
                                                                    <span>Chủ trì: {{item.eventItem.leaderName}}</span>
                                                                </v-flex>
                                                                
                                                                <v-flex xs3 sm2 style="text-align: center">
                                                                    <span>{{ parseDateView(new Date(item.eventItem.startDate))}}</span>
                                                                </v-flex>

                                                                <v-flex xs3 sm1 style="text-align: center">
                                                                    <v-icon color="red darken-3" title="Xóa" class="delete_icon"
                                                                    v-if="managerPermision(permission_prop)" icon 
                                                                    @click="deleteActivity(item,index,itemEventLink)">clear</v-icon>
                                                                </v-flex>
                                                            </v-flex>
                                                        </v-list-tile-title>

                                                    </v-list-tile-content>

                                                    <v-list-tile-action style="flex-direction: row;min-width: 0px!important"
                                                    title="Xem kết luận cuộc họp" @click="getListActivitySource(item.eventItem.activityId,index)"
                                                    >
                                                        <v-btn icon>
                                                            <v-icon>keyboard_arrow_down</v-icon>
                                                        </v-btn>
                                                    </v-list-tile-action>
                                                </v-list-tile>

                                                <!-- end -->
                                                <v-list-tile-content>
                                                    <v-data-table id="subTableActivity"
                                                    hide-headers
                                                    no-data-text="Không có kết luận"
                                                    :items="item.activitySourceItems"
                                                    item-key="activityId"
                                                    hide-actions
                                                    >
                                                        <template slot="items" scope="props">
                                                            
                                                            <tr v-bind:class="{'active': props.index%2==1}">
                                                                <td class="text-xs-center py-2" style="width: 5%">{{props.index + 1}}</td>
                                                                <td class="py-2" style="width: 30%" :title="props.item.subject">
                                                                    <a href="javascript:;" v-on:click.stop="activityDetail(props.item,props.index)">
                                                                        <span>{{ props.item.subject }}</span>
                                                                    </a>
                                                                    
                                                                </td>
                                                                <td class="py-2" style="width: 20%" :title="props.item.hosting ">{{ props.item.hosting }}</td>
                                                                <td class="text-xs-center py-2" style="width: 12%">{{parseDateView(new Date(props.item.endDate))}}</td>
                                                                <td class="text-xs-center" style="width: 13%">
                                                                    <v-chip style="display: inline-block;text-align: center;width:90%" label outline :color="getColor(props.item.state)">
                                                                        <span>{{props.item.stateName}}</span>
                                                                    </v-chip>
                                                                    
                                                                </td>
                                                                <td class="py-2" style="width: 20%" :title="props.item.resultNote">{{ props.item.resultNote }}</td>
                                                            </tr>
                                                            
                                                        </template>
                                                    </v-data-table>
                                                    
                                                </v-list-tile-content>
                                            </v-list-group>
                                        </v-list>
                                        
                                    </v-card>
                                </v-flex>
                            </v-layout>
                        </v-card-text>
                    </v-card>
                </v-expansion-panel-content>
            </v-expansion-panel>

        </div>
    </div>
</template>


<script>
    const COMPONENT_NAME = 'jx-mobilink-activity-eventsource'

    export default {
        name: COMPONENT_NAME,
        props: {
            id: null,
            class_pk: null,
            class_name: null,
            group_id: null,
            end_point: null,
            working_unit_prop: null,
            permission_prop: null,
            startend_prop:null
        },

        created () {
            var vm = this
            vm.$nextTick(function () {
                vm.initEventLink()
            })
        },
        data () {
            return {
                itemEventLink: [],
                dialog_add_eventlink: false
            }
        },
        
        methods: {
            initEventLink: function(){
                var vm = this;
                console.log(vm._props);
                vm.getActivityLink()
            },
            show_add_link: function(){
                var vm = this;
                vm.dialog_add_eventlink = true;
            },
            /**Load activity detail */
            activityDetail: function(item, index){
                this.$emit('view_detail', item, index);
            },
            /**delete activity */
            deleteActivity: function (item, index, items) {
                this.$emit('delete_activity', item, index, items);
            },
            /**Check permision */
            managerPermision: function(permision){
                if(permision=='manager'||permision=='hoster'||permision=='owner'||permision=='leader'){
                    return true
                } else {return false}
            },
            /**parse date */
            parseDateView : function(fullDate){
                var date;
                if(fullDate){
                    date = fullDate.getDate().toString().padStart(2, '0')+'/'+(fullDate.getMonth()+1).toString().padStart(2, '0')+'/'+fullDate.getFullYear();
                } else {
                    date = ""
                }
                return date
            },
            getActivityLink: function(){
                /*console.log("run get getActivity");*/
                var vm = this;

                var paramsGetActivityLink = {
                    sort:'startDate_Number'
                    
                };
                vm.paramsGet = paramsGetActivityLink;
                var configGetActivityLink = {
                    params: vm.paramsGet,
                    headers: {
                        groupId: vm.group_id
                    }
                };
                var url = vm.end_point + 'activities/' + vm.class_pk + '/links';
                axios.get(url, configGetActivityLink).then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.itemEventLink.push({
                                eventItem: serializable.data[key],
                                activitySourceItems:[]
                            })

                        };
                                                
                    }
                    console.log(vm)
                })
                .catch(function (error) {
                    console.log(error);
                    
                });
            },
            /** get list source group*/
            getListActivitySource: function(class_pk,index){
                var vm =this;
                var paramsGetSource = {
                    
                };
                const configGetSource = {
                    params: paramsGetSource,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                if(vm.itemEventLink[index].activitySourceItems.length==0){
                    axios.get( vm.end_point + 'activities/source/'+vm.class_name+'/'+ class_pk, configGetSource)
                    .then(function (response) {
                        var serializable = response.data
                        if (serializable.hasOwnProperty('data')) {
                            for (var key in serializable.data) {
                                vm.itemEventLink[index].activitySourceItems.push(
                                    serializable.data[key]
                                )
                            
                            }
                        }
                    })
                    .catch(function (error) {
                        console.log(error)
                    })
                }
                
            },
            /** */
            getColor: function(item){
                var color;
                switch (item) {
                    case 1:
                        color = "red";
                        break;
                    case 2:
                        color = "red";
                        break;
                    case 3:
                        color = "red";
                        break;
                    case 4:
                        color = "blue";
                        break;
                    case 5:
                        color = "blue";
                        break;
                    case 6:
                        color = "teal";
                        break;
                    case 7:
                        color = "amber";
                        break;
                    case 8:
                        color = "grey";
                        break;
                    case 9:
                        color = "pink";
                        break;
                    case 10:
                        color = "cyan";
                        break;
                    case 11:
                        color = "purple";
                        break;
                    case 12:
                        color = "indigo";
                        break;
                        
                }
                return color
            },
        }

    }
</script>

<style>
    .subEl {
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    .subEl a:hover{
        color: #1a5eba!important;
    }
    #activity_eventsource .card li {
        border-bottom: 1px dashed #ddd;
    }
    #activity_eventsource .delete_icon:hover{
        cursor: pointer;
    }
    #activity_eventsource table tr td{
        overflow: hidden;
        text-overflow: ellipsis; 
        white-space: nowrap;
        padding: 8px 5px!important;
    }
    #activity_eventsource table{
        table-layout: fixed
    }
    #activity_eventsource .mx-datepicker{
        width: 100%!important
    }
</style>

