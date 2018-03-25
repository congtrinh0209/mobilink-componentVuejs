<template>
    <div id="activity_invitation_task">
        <div style="position: relative; overflow: hidden;">
            <v-toolbar
                absolute
                color="teal lighten-3"
                dark
                scroll-off-screen
            >
                <v-toolbar-title class="ml-3">Giao thực hiện/ phối hợp</v-toolbar-title>
                <v-spacer></v-spacer>
                
            </v-toolbar>
            <!-- Phần đơn vị/ Nhóm trong cơ quan-->
            <v-expansion-panel style="padding-top:65px" expand>
                <v-expansion-panel-content value="true">
                    <div slot="header" class="custome-panel-heading-with-icon mr-2 pl-0">
                        <div><b>Đơn vị/ Nhóm trong cơ quan</b></div>
                        <v-btn fab small grey lighten-3 class="btn-add mx-0 my-0" v-on:click.stop="show_Add1">
                            <v-icon grey darken-4>add</v-icon>
                        </v-btn>
                    </div>
                    
                    <v-card class="pl-2 pr-1">
                        <v-card-text class="px-0 py-0">
                            <v-layout row wrap class="mx-0">
                                <v-flex class="mb-3 layout wrap" v-if="showAdd1">
                                    <v-flex xs9>
                                        <v-select class="selectBoder pt-3"
                                        placeholder="Chọn đơn vị/nhóm"
                                        :items="items"
                                        v-model="e1"
                                        :clearable="true"
                                        ></v-select>
                                    </v-flex>
                                    <toggle-button class="mx-1 mt-4"
                                    :value="false"
                                    v-model="typeAdd"
                                    :labels="{checked: 'TH', unchecked: 'PH'}"
                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                    :width="50"/>
                                    <v-btn small outline color="primary" class="mx-0 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">Giao</v-btn>

                                </v-flex>
                                
                                <v-flex xs12 sm12>
                                    <v-card>
                                        <v-list >
                                            <v-list-group v-for="item in items" :value="item.active" v-bind:key="item.title">
                                                <!-- Phần danh sách tổ chức/ đơn vị -->
                                                <v-list-tile slot="item" class="px-0">
                                                    <v-list-tile-content class="px-0">
                                                        <v-flex xs12 class="layout wrap">
                                                            <v-flex xs9 class="pt-2">
                                                                <v-list-tile-title class="item_group">{{ item.title }}</v-list-tile-title>
                                                            </v-flex>

                                                            <v-flex xs3>
                                                                <div class="right">
                                                                    <v-chip label outline color="primary" class="mr-2 mt-2">2</v-chip>
                                                                    <v-btn icon title="Xóa" class="mx-0">
                                                                        <v-icon color="red darken-3">clear</v-icon>
                                                                    </v-btn>
                                                                </div>
                                                                 
                                                            </v-flex>
                                                            
                                                        </v-flex>
                                                        <v-divider xs12 class="mt-0"></v-divider>
                                                    </v-list-tile-content>
                                                    
                                                </v-list-tile>
                                                
                                                <!-- end -->

                                                    <!-- Phần thêm cá nhân trong tổ chức/ đơn vị -->
                                                    <div class="layout wrap mx-0 mb-2">
                                                        <toggle-button class="mr-1 mt-4"
                                                        :value="false"
                                                        v-model="typeAddSub"
                                                        :labels="{checked: 'TH', unchecked: 'PH'}"
                                                        :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                        :width="50"/>
                                                        <v-flex xs9>
                                                            <v-select class="selectBoder pt-3"
                                                            placeholder="Cá nhân trong đơn vị/nhóm"
                                                            :items="items"
                                                            v-model="e1"
                                                            :clearable="true"
                                                            ></v-select>
                                                        </v-flex>
                                                        <v-btn small outline color="primary" class="mx-0 ml-1 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">Giao</v-btn>
                                                    </div>
                                                    <!-- end -->

                                                <!-- Phần danh sách cá nhân trong tổ chức/ đơn vị -->
                                                <v-list-tile v-for="subItem in item.items" v-bind:key="subItem.title">
                                                    <v-list-tile-content class="mt-2">
                                                        <v-flex xs12 class="layout wrap">
                                                            <v-flex xs10 class="pt-1">
                                                                <v-list-tile-title>
                                                                    <toggle-button class="mr-1 mt-2" :value="true"
                                                                    :labels="{checked: 'TH', unchecked: 'PH'}"
                                                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                                    :width="50"/>
                                                                    <span class="pt-2">{{ subItem.title }}</span>
                                                                </v-list-tile-title>
                                                            </v-flex>
                                                            
                                                            <v-flex xs2>
                                                                <div class="right">
                                                                    <v-btn icon title="Xóa" class="mx-0 ml-2">
                                                                        <v-icon color="red darken-3">clear</v-icon>
                                                                    </v-btn> 
                                                                </div>
                                                            </v-flex>
                                                            
                                                        </v-flex>

                                                    </v-list-tile-content>  
                                                </v-list-tile>
                                                <!-- end -->
                                                <v-divider class="mt-0"></v-divider>

                                            </v-list-group>
                                        </v-list>
                                    </v-card>
                                </v-flex>
                            </v-layout>
                        </v-card-text>
                    </v-card>
                </v-expansion-panel-content>
            </v-expansion-panel>
            <v-divider class="my-0"></v-divider>

            <!-- Phần cá nhân theo danh bạ -->
            <v-expansion-panel expand class="mt-3">
                <v-expansion-panel-content value="true">
                    <div slot="header" class="custome-panel-heading-with-icon pr-2 pl-0">
                        <div><b>Cá nhân/ Tổ chức theo danh bạ</b></div>
                        <v-btn fab small grey lighten-3 class=" btn-add mx-0 my-0" v-on:click.stop="show_Add2">
                            <v-icon grey darken-4>add</v-icon>
                        </v-btn>
                    </div>
                    
                    <v-card class="pl-2 pr-1">
                        <v-card-text class="px-0 pt-0">
                            <v-layout row wrap class="mx-0">
                                <v-flex class="layout wrap" v-if="showAdd2">
                                    <v-flex xs9>
                                        <v-select class="selectBoder pt-3"
                                        placeholder="Cá nhân/ tổ chức theo danh bạ"
                                        :items="items"
                                        v-model="e1"
                                        :clearable="true"
                                        ></v-select>
                                    </v-flex>
                                    <toggle-button class="mx-1 mt-4"
                                    :value="false"
                                    v-model="typeAdd"
                                    :labels="{checked: 'TH', unchecked: 'PH'}"
                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                    :width="50"/>
                                    <v-btn small outline color="primary" class="mx-0 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">Giao</v-btn>

                                </v-flex>
                                
                                <v-flex xs12 sm12>
                                    <v-card>
                                        <!-- Phần danh sách cá nhân theo danh bạ -->
                                        <v-list >
                                            <v-list-tile v-for="item in items2" v-bind:key="item.title">
                                                <v-list-tile-content class="mt-2">
                                                    <v-list-tile-title>
                                                        <v-flex xs12 class="layout wrap">
                                                            <v-flex xs10 class="pt-1">
                                                                <v-list-tile-title>
                                                                    <toggle-button class="mr-1 mt-2" :value="true"
                                                                    :labels="{checked: 'TH', unchecked: 'PH'}"
                                                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                                    :width="50"/>
                                                                    <span class="pt-2">{{ item.title }}</span>
                                                                </v-list-tile-title>
                                                            </v-flex>
                                                            
                                                            <v-flex xs2>
                                                                <div class="right">
                                                                    <v-btn icon title="Xóa" class="mx-0 ml-2">
                                                                        <v-icon color="red darken-3">clear</v-icon>
                                                                    </v-btn> 
                                                                </div>
                                                            </v-flex>
                                                            
                                                        </v-flex>
                                                        
                                                    </v-list-tile-title>
                                                    <v-divider class="mt-0"></v-divider>
                                                </v-list-tile-content>  
                                            </v-list-tile>
                                            
                                        </v-list>
                                        <!-- end -->
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
    const COMPONENT_NAME = 'jx-mobilink-activity-invitation-task'

    export default {
        name: COMPONENT_NAME,
        props: {
            id: null,
            class_pk: null,
            class_name: null,
            group_id: null,
            end_point: null,

        },

        created () {
            
        },
        
        data () {
            return {
                switch1: true,
                typeCheckin: true,
                dialog: false,
                showAdd1: false,
                showAdd2: false,

                items: [
                    {
                        title: 'Phòng tài chính',
                        // active: true,
                        items: [
                            { title: 'Trịnh Công Trình' },
                            { title: 'Nguyễn Văn Thành' },
                            { title: 'Lê Tiến Hoàn' }
                        ]
                    },
                    {
                        title: 'Lãnh đạo các phường',
                        items: [
                            { title: 'Trịnh Công Trình' }
                        ]
                    },
                    {
                        title: 'Văn hóa thông tin',
                        items: [
                            { title: 'Nguyễn Văn Thành' }
                        ]
                    },
                    {
                        title: 'Bộ phận một cửa',
                        items: [
                            { title: 'Lê Tiến Hoàn' }
                        ]
                    }
                ],
                // 
                items2: [
                    { title: 'Trịnh Công Trình' },
                    { title: 'Nguyễn Văn Thành' },
                    { title: 'Lê Tiến Hoàn' }
                ]
            }
        },
        methods: {
            initAddActivity: function(){
                var vm = this;
                /** */
                var paramsGetActivity = {
                    
                };
                const configGetActivity = {
                    params: paramsGetActivity,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                /* Load data đơn vị tổ chức/ chủ trì */
                axios.get( endPoint + 'activities/' + vm.class_pk + '/invitations', configGetActivity)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })
                /** */
            },


            checkin: function(){
                var vm =this;
                vm.typeCheckin = !vm.typeCheckin;
            },
            show_Add1: function(){
                var vm =this;
                vm.showAdd1 =!vm.showAdd1
            },
            show_Add2: function(){
                var vm =this;
                vm.showAdd2 =!vm.showAdd2
            },
  
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
    #activity_invitation_task .toolbar__title{
        font-size: 13px!important;
    }
    #activity_invitation_task .btn__content {
        padding-left: 0px!important;
        padding-right: 0px!important;
    }
    #activity_invitation_task .expansion-panel__header{
        padding-left: 10px!important;
        padding-right: 10px!important;
    }
    #activity_invitation_task .list__tile{
        padding: 0!important;
    }
    #activity_invitation_task .list__tile__title{

        height: 100%!important;
    }
    #activity_invitation_task .list__tile__content{
        overflow: visible!important;
    }
    #activity_invitation_task .item_group:hover{
        color: blue;
        cursor: pointer;
    }
    #activity_invitation_task .chip {
        max-height: 30px!important
    }
    #activity_invitation_task .selectBoder .input-group__input{
        border: 1px solid #1976D2 ;
        border-radius: 4px;
        padding-left: 8px;
    }
    #activity_invitation_task .selectBoder .input-group__details {
        display: none
    }
    #activity_invitation_task  .iconCmm {
        color: #1976D2
    }
    #activity_invitation_task .invBtn{
        margin-top: 19px!important;
    }
    #activity_invitation_task .btn-add{
        width: 30px;
        height: 30px;
    }
</style>

