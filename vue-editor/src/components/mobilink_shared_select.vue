<template>
  <div >
    <v-select
      return-object
      :label="label"
      v-bind:items="items"
      v-model="inputVal"
      :item-text="itemText"
      :item-value="itemValue"
      multiple
      chips
      max-height="auto"
      hide-selected
      autocomplete
      >
          <template slot="selection" slot-scope="data">
              <v-chip
                  close
                  @input="data.parent.selectItem(data.item)"
                  :selected="data.selected"
                  class="chip--select-multi"
                  :key="JSON.stringify(data.item)"
              >
                  <v-avatar @click.stop.prevent="changePermissionSelectedFunc(data.item)" class="green darken-2" style="color: white; cursor: pointer;" v-if="data.item.right === 2"> W </v-avatar>
                  <v-avatar @click.stop.prevent="changePermissionSelectedFunc(data.item)" class="cyan darken-1" style="color: white; cursor: pointer;" v-if="data.item.right === 1"> S </v-avatar>
                  <v-avatar @click.stop.prevent="changePermissionSelectedFunc(data.item)" class="accent" style="cursor: pointer;" v-if="data.item.right === 0"> R </v-avatar>
                  {{ data.item[itemText] }}
              </v-chip>
          </template>
      </v-select>
  </div>
</template>

<script>
const COMPONENT_NAME = 'jx-mobilink-share-select'

export default {
  name: COMPONENT_NAME,
  props: {
    label: '',
    vModel: '',
    value: '',
    itemText: '',
    itemValue: '',
    items: []
  },
  data () {
    return {
      inputVal: this.value
    }
  },
  watch: {
    inputVal(val) {
      this.$emit('input', val);
    }
  },
  methods: {
    changePermissionSelectedFunc: function (item) {
      item.right = item.right + 1
      if (item.right > 2) {
        item.right = 0
      }
    }
  }
}
</script>

<style>

</style>
