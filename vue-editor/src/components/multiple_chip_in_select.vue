<template>

    <div :id="'chip-in-select'+id">
        <v-flex xs12 sm2>
            <v-subheader class="px-0">Đơn vị phối hợp:</v-subheader>
        </v-flex>
        <v-flex xs12 sm10>

            <v-select
                v-bind:items="resourceTagItems"
                v-model="resourceTag"
                chips
                tags
                item-text="name"
                item-value="id"
                return-object
                @change = "change"
                :disabled = "managerPermision(vm.permission_prop)?false:true"
            >
                <template slot="selection" scope="data">
                    <v-chip
                        @input="eventInput(data)"
                        class="chip--select-multi"
                        :selected="data.selected"
                        :disabled="data.disabled"
                        :key="JSON.stringify(data.item)"
                        close
                    >
                        
                        {{ data.item.name?data.item.name:data.item}}
                    </v-chip>
                </template>
            </v-select>

            <v-button @click= "getData">change</v-button>
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
                vm.initResourceTags()
            })
        },
        data () {
            return {
                resourceTag: [],
                resourceTagItems: []

            }
        },
        
        methods: {
            initResourceTags: function(){
                var vm = this;
                var paramsGetTags = {
                    
                };
                const configGetTags = {
                    params: paramsGetTag,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'resourcetags/'+vm.class_name+'/'+vm.class_pk, configGetTags)
                .then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.resourceTagItems.push({
                                tag: serializable.data[key].tag,
                                resourceTagId: serializable.data[key].resourceTagId,
                            })
                            
                        }
                    }
                    vm.getResourseTagClassPk()
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
                })
                .catch(function (error) {
                    console.log(error)
                })
            },
            change: function(){
                var vm =this;
                setTimeout(function(){
                    console.log(vm)
                    // var marvelHeroes = [];
                    // console.log(vm.resourceTag);
                    
                    // var marvelHeroes = vm.resourceTagItems.filter (function(item) {
                    //     for(var i=0; i<=vm.resourceTag.length; i++ ) {
                    //         if(item.id == vm.resourceTag[i] ){
                    //             return item;
                    //         }
                    //     }
                        
                    // });
                    // console.log(marvelHeroes)
                },2000)
                
            },
            eventInput: function(data){
                var vm = this;
                
                console.log(data);
                data.parent.selectItem(data.item);
                setTimeout(function(){
                    console.log(vm)
                },1000)
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
    
    @media only screen and (min-width: 320px) and (max-width: 1024px) {
        

    }
</style>

