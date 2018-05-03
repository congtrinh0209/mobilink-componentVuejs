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

            <!-- Phần cá nhân theo danh bạ -->
            <v-expansion-panel expand class="sub-panel">
                <v-expansion-panel-content value="true">
                    <div slot="header" class="custome-panel-heading-with-icon pl-0 mr-2">
                        <div class="">Cuộc họp nguồn/ liên quan</div>

                        <v-icon class="btn-add mx-0 my-0" v-on:click.stop="show_add_source" 
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
                                <!-- Phần dialog thêm mới liên lạc postInvitation('UserContact')-->
                                <v-dialog v-model="dialog_add_eventsource" scrollable persistent max-width="700px">
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
                                            <v-btn class="mr-3" color="primary"  @click.native="dialog_add_eventsource= false">Hủy</v-btn>
                                            <v-btn color="primary" @click.native="submitAddContact" >Thêm vào liên lạc</v-btn>
                                        </v-card-actions>
                                    </v-card>
                                </v-dialog>
                                <!-- end -->

                                <v-flex xs12 sm12>
                                    <v-card>
                                        <!-- Phần danh sách cá nhân theo danh bạ -->
                                        <v-list class="py-0">
                                            <v-list-tile v-for="(item, index) in itemEventSource" v-bind:key="item.activityId">
                                                <v-list-tile-content>
                                                    <v-list-tile-title>
                                                        <v-flex xs12 class="layout wrap">

                                                            <v-flex xs6 sm6 class="pr-2 subEl">
                                                                <v-icon class="mr-2">fa-gg</v-icon>
                                                                <a href="javascript:;" :title="item.subject" v-on:click="activityDetail(item,index)">
                                                                    {{item.subject}}
                                                                </a>
                                                            </v-flex>
                                                            
                                                            <v-flex xs3 sm3 class="pl-2">
                                                                <span>Chủ trì: {{item.leaderName}}</span>
                                                            </v-flex>
                                                            
                                                            <v-flex xs3 sm2 style="text-align: center">
                                                                <span>{{ parseDateView(new Date(item.startDate))}}</span>
                                                            </v-flex>

                                                            <v-flex xs3 sm1 style="text-align: center">
                                                                <v-icon color="red darken-3" title="Xóa" class="delete_icon"
                                                                v-if="managerPermision(permission_prop)" icon 
                                                                @click="deleteActivity(item,index,itemEventSource)">clear</v-icon>
                                                            </v-flex>
                                                        </v-flex>
                                                    </v-list-tile-title>

                                                </v-list-tile-content>
                                            </v-list-tile>
                                            
                                        </v-list>
                                        <!-- end -->
                                        <p v-if="itemEventSource.length == 0" class="mt-3 ml-2">Không có giấy mời</p>
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
                vm.initEventSource()
            })
        },
        data () {
            return {
                itemEventSource: [
                    {"activityId":1301,"resultNote":"Kết luận thanh tra Ban quản lý dự án","leaderId":101,"leaderName":"Trịnh Công Trình","userId":20156,"userName":"Admin Super","createDate":"2018-02-28T13:42:28.000Z","modifiedDate":"2018-02-28T13:42:28.000Z","activityType":"EVENT","activityCat":"","categoryName":"","projectId":0,"projectName":"","subject":"Nghiệm thu nội bộ TVGS","hostingId":1,"hosting":"","locationId":101,"location":"Tòa nhà Vapa, Tôn Thất Thuyết, Dịch Vọng Hậu, Hà Nội, Việt Nam","geolocation":"","startDate":1523430000000,"endDate":1523430000000,"state":2,"onCalendar":false,"isTemplate":false,"templateNo":"","managerId":1,"managerName":"Trịnh Công Trình","okrArchive":0,"overdue":0,"permission":"","visited":false,"participators":[{"workingUnitId":1,"name":"Mobilink"},{"workingUnitId":101,"name":"TEST"}],"contact":{"contactId":101,"fullname":"Thanh NV","companyName":"FDS","telNo":"0978266524","email":"thanhnv@fds.vn","userMappingId":0}},
                    {"activityId":1601,"resultNote":"Kết luận thanh tra Ban quản lý dự án","leaderId":102,"leaderName":"Vũ  Đình Dũng","userId":20158,"userName":"Admin Super","createDate":"2018-02-28T18:11:02.000Z","modifiedDate":"2018-02-28T18:11:02.000Z","activityType":"EVENT","activityCat":"EVENT1","categoryName":"Sự kiện 1","projectId":0,"projectName":"","subject":"Báo cáo tuần 11 năm 2018","hostingId":3,"hosting":"Mobilink","locationId":101,"location":"Tòa nhà Vapa, Tôn Thất Thuyết, Dịch Vọng Hậu, Hà Nội, Việt Nam","geolocation":"","startDate":1523430000000,"endDate":1523430000000,"state":3,"onCalendar":true,"isTemplate":false,"templateNo":201,"managerId":1,"managerName":"Nguyễn Văn Thành","okrArchive":0,"overdue":0,"permission":"","visited":false,"participators":[{"workingUnitId":1,"name":"Mobilink"},{"workingUnitId":101,"name":"TEST"}],"contact":{"contactId":101,"fullname":"Thanh NV","companyName":"FDS","telNo":"0978266524","email":"thanhnv@fds.vn","userMappingId":0}}
                    
                ],
                dialog_add_eventsource: false
            }
        },
        
        methods: {
            initEventSource: function(){
                var vm = this;
                console.log(vm._props);
            },
            show_add_source: function(){
                var vm =this;
                vm.dialog_add_eventsource = true;
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
</style>

