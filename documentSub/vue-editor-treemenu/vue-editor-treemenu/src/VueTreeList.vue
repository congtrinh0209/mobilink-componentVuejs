<template>
  <div>
    <div v-if="model.name !== 'root'">
      <div class="border up"></div>

      <div class='tree-node py-0 ' :id='model.id' :root="model.pid" :ptype="model.ptype" :class="{'tree-parent': !model.isLeaf, 'selected': selected === model.id}"
        @mouseover='mouseOver'
        @mouseout='mouseOut'>
        <span class="caret-flat" v-if="!model.isLeaf || model.children" >
          <v-btn flat fab small v-if="!this.expanded" @click.prevent.stop="toggle(model)" class="mx-0 my-0 tree__btn"><v-icon>chevron_right</v-icon></v-btn>
          <v-btn flat fab small v-if="this.expanded" @click.prevent.stop="toggle(model)" class="mx-0 my-0 tree__btn"><v-icon>expand_more</v-icon></v-btn>
        </span>
   
        <div class="tree-content truncate-text" @click.prevent.stop="toggle(model)" v-if="model.name != null && model.name.length > 30">
          <v-icon v-if="model.folder_icon === 'folder'" class="icon__folder">{{model.folder_icon}}</v-icon>
          <v-icon v-else>{{model.folder_icon}}</v-icon>
          <v-tooltip right>
            <span slot="activator">{{model.name}}</span>
            <span>{{model.name}}</span>
          </v-tooltip>
        </div>
        <div class="tree-content truncate-text" @click.prevent.stop="toggle(model)" v-else>
          <v-icon v-if="model.folder_icon === 'folder'" class="icon__folder">{{model.folder_icon}}</v-icon>
          <v-icon v-else>{{model.folder_icon}}</v-icon>
          {{model.name}}
        </div>
      </div>

      <div class="border bottom"></div>
    </div>
    <div v-if="model.pid == undefined" class="is__root__level">
      {{model.pid}}
    </div>
    <div class="py-0" :class="{'tree-margin': model.name !== 'root', 'tree-parent': (model.children && model.children.length > 0)}" v-show="this.expanded" v-if="isFolder">
      <item v-for="model in model.children"
        :default-tree-node-name="defaultTreeNodeName"
        :default-leaf-node-name="defaultLeafNodeName"
        :model="model"
        :key='model.id'>
      </item>
    </div>
  </div>
</template>

<script>
  import { Tree, TreeNode } from './Tree.js'

  let fromComp = ''
  export default {
    data: function () {
      return {
        isHover: false,
        expanded: false,
        selected: -1
      }
    },
    props: {
      model: {
        type: Object
      },
      defaultLeafNodeName: {
        type: String,
        default: 'New leaf node'
      },
      defaultTreeNodeName: {
        type: String,
        default: 'New tree node'
      }
    },
    computed: {
      isFolder() {
        return this.model.children &&
          this.model.children.length
      }
    },
    mounted () {
      
    },
    beforeDestroy () {
    },
    methods: {

      toggle(item) {
        
        this.selected = item.id
        this.expanded = !this.expanded
        var currentItemt = {
          isFolder: this.isFolder,
          item: item
        }
        var vm = this
        var toggleItem = 'toggle-item';
        try {
            vm.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parenat.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
            vm.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$parent.$emit(toggleItem, currentItemt)
        }
        catch(err) {
        }
        var elements = document.querySelectorAll(".tree-node.selected")
        for (var i = 0; i < elements.length; i++) {
          elements[i].classList.remove('selected');
        }
        var curDOM = document.getElementById(item.id)
        if (!curDOM.classList.contains('selected')) {
          curDOM.classList.add("selected")
        }
      },

      mouseOver(e) {
        this.isHover = true
      },

      mouseOut(e) {
        this.isHover = false
      }

    },
    beforeCreate () {
      this.$options.components.item = require('./VueTreeList.vue')
    }
  }
</script>

<style lang="less" rel="stylesheet/less" scoped>

  .tree-node {
    display: flex;
    align-items: center;
    padding: 0px;
    position: relative;
  }


  .item {
    cursor: pointer;
  }
  .tree-margin {
    margin-left: 15px;
  }

  .operation .btn{
    margin: 0;
  }
  .operation .btn--small .btn__content{
    padding: 0;
  }
  .tree-counter{
    position: absolute;
    right: 15px;
    margin-left: 0px !important;
    min-width: 50px;
    text-align: right;
  }
  body .is__root__level + .tree-parent {
    display: block !important;
  }
  .tree-content {
    cursor: pointer;
    display: flex;
    display: -webkit-flex;
    align-items: center;
    min-height: 40px;
  }
  .tree-content .material-icons{
    padding-right: 5px !important;
  }
  .caret-flat .btn .material-icons{
    padding-right: 0px !important;
  }
  .tree-node.selected {
    background-color: #f0f0f0;
  }
  .btn--floating.btn--small.tree__btn {
    width: 25px !important;
     height: 25px !important;
  }
  body .tree-content .tooltip{
    opacity: 1;
  }
  body .truncate-text .tooltip > span > span{
        display: block;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    word-break: normal \9;
    word-wrap: normal;
  }
  
</style>
