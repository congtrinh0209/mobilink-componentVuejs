<template>

    <div :id="'chip-in-select'+id" class="chip-in-select">
        <!-- <v-flex xs12 sm2>
            <v-subheader class="px-0">Thẻ nhãn:</v-subheader>
        </v-flex> -->
        <v-flex xs12 sm12>

            <v-select
                placeholder="Thêm thẻ nhãn"
                v-bind:items="resourceTagItems"
                v-model="resourceTag"
                chips
                tags
                item-text="tagCount"
                item-value="resourceTagId"
                return-object
                hide-selected
                @input = "searchTag($event)"
                @keyup.delete = "keyupDelete($event)"
                :disabled = "managerPermision(permission_prop)?false:true"
            >
                <template slot="selection" scope="data">
                    <v-chip
                        @input="deleteTag(data)"
                        class="chip--select-multi"
                        :selected="data.selected"
                        :disabled="data.disabled"
                        :key="JSON.stringify(data.item)"
                        close
                    >
                        
                        {{ data.item.tag?data.item.tag:data.item}}
                    </v-chip>
                </template>
            </v-select>

        </v-flex>

    </div>
</template>


<script>
    const COMPONENT_NAME = 'jx-mobilink-chip-select'

    export default {
        name: COMPONENT_NAME,
        props: {
            id: null,
            class_pk: null,
            class_name: null,
            group_id: null,
            end_point: null,
            permission_prop: null,
            startend_prop:null
        },
        watch: {
            
        },
        created () {
            var vm = this
            vm.$nextTick(function () {
                console.log("props resourceTag-->");
                console.log(vm._props);
                vm.initResourceTags()
            })
        },
        data () {
            return {
                resourceTag: [],
                resourceTagItems: [],
                eventSearchTag: true,
                currentSeclected: 0,
                currentResourceTag:[]
            }
        },
        
        methods: {
            keyupDelete: function(event){
                var vm = this;
                // console.log(event);
                // console.log(vm);
                if(vm.resourceTag.length<vm.currentResourceTag.length){
                    var tagFilter = {};
                    for (var key in vm.currentResourceTag) {
                        
                        var itemTag = true;
                        for(var keys in vm.resourceTag){
                            if(vm.currentResourceTag[key].resourceTagId == vm.resourceTag[keys].resourceTagId){
                                itemTag = false;
                                break;
                            }
                        }
                        if(itemTag){
                            tagFilter = vm.currentResourceTag[key]
                        }
 
                    }
                    // console.log(tagFilter);
                    vm.deleteRessourceTag(tagFilter.resourceTagId)
                }

            },
            initResourceTags: function(){
                var vm = this;
                vm.getResourseTagClassPk()
            },
            
            getResourseTag: function(){
                var vm = this;
                var paramsGetTags = {
                    
                };
                const configGetTags = {
                    params: paramsGetTags,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                vm.resourceTagItems = [];
                axios.get( vm.end_point + 'resourcetags', configGetTags)
                .then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            if(vm.resourceTag.length>0){
                                var itemTag = true;
                                for(var keys in vm.resourceTag){
                                    if(serializable.data[key].tag == vm.resourceTag[keys].tag){
                                        itemTag = false;
                                        break;
                                    }
                                }
                                if(itemTag){
                                    vm.resourceTagItems.push({
                                        tag: serializable.data[key].tag,
                                        tagCount: serializable.data[key].tag + ' (' + serializable.data[key].count + ')',
                                        resourceTagId: serializable.data[key].resourceTagId,
                                    })
                                }
                            } else {
                                vm.resourceTagItems.push({
                                    tag: serializable.data[key].tag,
                                    tagCount: serializable.data[key].tag + ' (' + serializable.data[key].count + ')',
                                    resourceTagId: serializable.data[key].resourceTagId,
                                })
                            }
                            
                        }
                    }
                    
                })
                .catch(function (error) {
                    console.log(error)
                })
            },
            getResourseTagClassPk: function(){
                var vm = this;
                var paramsGetTagsClassPk = {
                    
                };
                const configGetTagClassPk = {
                    params: paramsGetTagsClassPk,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                vm.resourceTag = [];
                axios.get( vm.end_point + 'resourcetags/'+vm.class_name+'/'+vm.class_pk, configGetTagClassPk)
                .then(function (response) {
                    var serializable = response.data;
                    var dataTag = [];
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            dataTag.push({
                                tag: serializable.data[key].tag,
                                resourceTagId: serializable.data[key].resourceTagId,
                            })
                            
                        }
                        vm.resourceTag = dataTag
                    }
                    vm.currentSeclected = vm.resourceTag.length;
                    vm.currentResourceTag = vm.resourceTag;
                    vm.getResourseTag()
                })
                .catch(function (error) {
                    console.log(error)
                })
            },
            searchTag: function(event){
                var vm = this;
                setTimeout(function(){
                    // console.log(event.length+'--'+vm.currentSeclected)
                    if(event.length>vm.currentSeclected){
                        // console.log("Event Input Select");
                        // console.log(event);
                        var tagAdd = event[event.length-1];
                        if(typeof tagAdd == 'object'){
                            tagAdd = tagAdd.tag
                        }
                        console.log("-->tag = "+tagAdd);
                        vm.addRessourceTag(tagAdd)
                    }
                    return false
                },200)
                
            },
            addRessourceTag: function(tag){
                var vm = this;
                var dataPostResourceTag  =new URLSearchParams();
                dataPostResourceTag.append('className', vm.class_name);
                dataPostResourceTag.append('classPK', vm.class_pk);
                dataPostResourceTag.append('tag', tag);
                var paramsPostResourceTag = {
                    
                };
                const configPostResourceTag = {
                    params: paramsPostResourceTag,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                var urlUpdate = vm.end_point + "resourcetags";
                axios.post(urlUpdate, dataPostResourceTag, configPostResourceTag)
                .then(function (response) {
                    setTimeout(function(){
                        vm.getResourseTagClassPk();
                        showMessageToastr('success', 'Thêm thẻ nhãn thành công')
                       
                    },1000) ;
                    
                })
                .catch(function (error) {
                    showMessageByAPICode(error.response.status, error.response.data);
                    vm.getResourseTagClassPk();
                    console.log(error.response)
                });

            },
            deleteRessourceTag: function(tagId){
                var vm = this;
                var paramsDeleteResourceTag = {
                    
                };
                const configDeleteResourceTag = {
                    params: paramsDeleteResourceTag,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                var urlUpdate = vm.end_point + "resourcetags/"+tagId;
                axios.delete(urlUpdate, configDeleteResourceTag)
                .then(function (response) {
                    setTimeout(function(){
                        showMessageToastr('success', 'Xóa thẻ nhãn thành công');
                        vm.getResourseTagClassPk()
                    },1000)
                    
                })
                .catch(function (error) {
                    vm.getResourseTagClassPk();
                    showMessageByAPICode(error.response.status, error.response.data);
                    console.log(error.response)
                });

            },
            deleteTag: function(data){
                var vm = this;
                setTimeout(function(){
                    // console.log('Event Input Chip');
                    // console.log(data);
                    data.parent.selectItem(data.item);
                    var resourceTagId = data.item.resourceTagId;
                    vm.deleteRessourceTag(resourceTagId)
                },200)
                
            },
            managerPermision: function(permision){
                if(permision=='manager'||permision=='hoster'||permision=='owner'||permision=='leader'){
                    return true
                } else {return false}
            }
            
        }

    }
</script>

<style>
    .chip-in-select .input-group__input{
        padding: 5px;
        min-height: 55px;
        border: 1px solid #ddd;
        border-radius: 3px;
    }
    .chip-in-select .input-group__details{
        display: none
    }
    .chip-in-select .input-group--select{
        padding-top: 5px!important
    }
    .chip-in-select .input-group{
        max-width: 100%!important;
    }
    @media only screen and (min-width: 320px) and (max-width: 1024px) {
        

    }
</style>

