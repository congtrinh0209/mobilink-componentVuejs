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

                        <v-icon class="btn-add mx-0 my-0" v-on:click.stop="show_Add2" 
                        v-if="managerPermision(permission_prop)&&stateEvent(startend_prop)&&showAdd2==false" grey darken-4>
                            add_circle
                        </v-icon>
                        <v-icon class="btn-add mx-0 my-0" v-on:click.stop="show_Add2" 
                        v-if="managerPermision(permission_prop)&&stateEvent(startend_prop)&&showAdd2==true"
                        grey darken-4>
                            do_not_disturb_on
                        </v-icon>
                    </div>
                    
                    <v-card>
                        <v-card-text class="px-0 py-0 pl-2 pr-1">
                            <v-layout row wrap class="mx-0">
                                <!-- Phần dialog thêm mới liên lạc postInvitation('UserContact')-->
                                <v-dialog v-model="dialog_add_eventsource" persistent max-width="700px">
                                    <v-card>
                                        <v-card-title style="background-color: rgb(214, 233, 247)">
                                            <span>Thêm liên lạc</span>
                                        </v-card-title>

                                        <v-card-text>
                                            <!-- Template activity add contact --> 
                                            <v-form v-model="valid" ref="form" lazy-validation >
                                                <v-layout wrap >
                                                    
                                                    <!--  -->
                                                    <v-flex xs12 sm3 class="mt-2">
                                                        <v-subheader class="px-0">Tên cá nhân/ tổ chức *</v-subheader>
                                                    </v-flex>
                                                    <v-flex xs12 sm9>
                                                        <v-text-field
                                                            placeholder = ''
                                                            v-model="fullNameCot"
                                                            clearable="true"
                                                            :rules="[v => !!v || 'Trường dữ liệu bắt buộc']"
                                                            required
                                                        ></v-text-field>
                                                    </v-flex>
                                                    <!--  -->
                                                    <v-flex xs12 sm3 class="mt-2">
                                                        <v-subheader class="px-0">Email *</v-subheader>
                                                    </v-flex>
                                                    <v-flex xs12 sm9>
                                                        <v-text-field
                                                            placeholder = ''
                                                            v-model="emailCot"
                                                            clearable="true"
                                                            :rules="[v => !!v || 'Trường dữ liệu bắt buộc']"
                                                            required
                                                        ></v-text-field>
                                                    </v-flex>
                                                    <!--  -->
                                                    <v-flex xs12 sm3 class="mt-2">
                                                        <v-subheader class="px-0">Số điện thoại</v-subheader>
                                                    </v-flex>
                                                    <v-flex xs12 sm9>
                                                        <v-text-field
                                                            placeholder = ''
                                                            v-model="telNoCot"
                                                            clearable="true"
                                                        ></v-text-field>
                                                    </v-flex>
                                                    <!--  -->
                                                    <v-flex xs12 sm3 class="mt-2">
                                                        <v-subheader class="px-0">Cơ quan/ địa chỉ</v-subheader>
                                                    </v-flex>
                                                    <v-flex xs12 sm9>
                                                        <v-text-field
                                                            placeholder = ''
                                                            v-model="companyName"
                                                            clearable="true"
                                                        ></v-text-field>
                                                    </v-flex>
                                                    
                                                </v-layout>
                                            </v-form>
                                            <!-- end -->
                                        </v-card-text>

                                        <v-card-actions>
                                            <v-spacer></v-spacer>
                                            <v-btn class="mr-3" color="primary"  @click.native="dialog_add_contact= false">Hủy</v-btn>
                                            <v-btn color="primary" @click.native="submitAddContact" >Thêm vào liên lạc</v-btn>
                                        </v-card-actions>
                                    </v-card>
                                </v-dialog>
                                <!-- end -->

                                <v-flex xs12 sm12>
                                    <v-card>
                                        <!-- Phần danh sách cá nhân theo danh bạ -->
                                        <v-list class="py-0">
                                            <v-list-tile v-for="(item,index) in itemEventSource" v-bind:key="item.activityId">
                                                <v-list-tile-content>
                                                    <v-list-tile-title>
                                                        <v-flex xs12 class="layout wrap">

                                                            <v-flex xs6 sm6>
                                                                <v-list-tile-title class="pt-2">
                                                                    <toggle-button class="mr-1 mt-1"
                                                                    :disabled="(managerPermision(permission_prop)==true)?false:true"
                                                                    :value="bindPresenter(item.right)"
                                                                    @change="updatePresenterUserGroup($event,item.resourceInvitationId,itemInvContact)"
                                                                    title_checked = "Thành viên"
                                                                    title_unchecked = "Theo dõi"
                                                                    :labels="{checked: 'TV', unchecked: 'TD'}"
                                                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                                    :width="50"/>
                                                                    <v-tooltip top>
                                                                        <span class="pt-2" slot="activator">{{ item.fullName }}</span>
                                                                        <span>Email:{{ item.email }} - Tel:{{ item.telNo }}</span>
                                                                    </v-tooltip>
                                                                    
                                                                </v-list-tile-title>
                                                            </v-flex>
                                                            
                                                            <v-flex xs3 sm3>
                                                                <div class="right">
                                                                    <v-tooltip top :disabled="(item.userNote?false:true)">
                                                                        <v-btn icon slot="activator" :class="managerPermision(permission_prop)==false? pointerEvent : ''"
                                                                        @click.stop="showAddNote(item)" class="text-white mx-0 my-0" 
                                                                        >
                                                                            <v-icon class="iconCmm" >comment</v-icon>
                                                                        </v-btn>
                                                                        <span >{{item.userNote}}</span>
                                                                    </v-tooltip>
                                                                    
                                                                    <v-btn v-if="stateCheckin(startend_prop)==true" class="mx-0" small color="success"
                                                                    :class="managerPermision(permission_prop)==false? pointerEvent : ''"
                                                                    v-on:click.stop="checkAvailable('ready',item,null)" style="padding-left: 6px;padding-right: 6px"
                                                                    >
                                                                        <v-icon style="color: white" v-if="item.available == 1" >check</v-icon>
                                                                        Sẵn sàng
                                                                    </v-btn>
                                                                    <v-btn v-if="stateCheckin(startend_prop)==true" small class="text-white mx-0" 
                                                                    :class="managerPermision(permission_prop)==false? pointerEvent : ''"
                                                                    v-on:click.stop="checkAvailable('busy',item,null)" color="error"
                                                                    >
                                                                        <v-icon style="color: white" v-if="item.available == 2" >check</v-icon>
                                                                        Bận
                                                                    </v-btn>

                                                                    <!-- <span v-if="stateEvent(startend_prop)==true" class="mr-2" style="color:green"
                                                                    v-html="bindAvailableText(item.available)"></span> -->

                                                                    <v-btn v-if="stateCheckin(startend_prop)==false" 
                                                                    :class="managerPermision(permission_prop)==false||activeClick? pointerEvent : ''"
                                                                    v-on:click.stop="managerCheckin(item,null)"  outline small class="text-white mx-1" color="indigo">
                                                                        <v-icon color="indigo" v-if="item.checkin" >check</v-icon>
                                                                        Có mặt
                                                                    </v-btn>

                                                                    <v-btn icon title="Xóa" class="mx-0" v-if="managerPermision(permission_prop)==true"
                                                                    @click.stop="updateInvitation('DELETE',item.resourceInvitationId,index,itemInvContact)">
                                                                        <v-icon color="red darken-3">clear</v-icon>
                                                                    </v-btn> 
                                                                </div>
        
                                                            </v-flex>
                                                            
                                                            <v-flex xs3 sm2>

                                                            </v-flex>

                                                            <v-flex xs3 sm1>

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
            
        },
        data () {
            return {
                itemEventSource: [],
                dialog_add_eventsource: false
            }
        },
        
        methods: {

        }

    }
</script>

<style>
    
</style>

