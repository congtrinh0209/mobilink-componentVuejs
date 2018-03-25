<template>
    <div :class="{'star-rating': true, 'rating_process': loading}" >
    <span
      v-for="rating in ratings"
      v-bind:key="rating"
      class="star-rating__star"
      :class="{'is-selected': ((ratings.indexOf(value) >= ratings.indexOf(rating)) && ratings.indexOf(value) >= 0 ), 'is-hover': ((temp_value >= ratings.indexOf(rating))), 'is-disabled': ((temp_value < ratings.indexOf(rating)))}"
      v-on:click="set(rating)" v-on:mouseover="star_over(rating)" v-on:mouseout="star_out"
      >
      <input class="star-rating star-rating__checkbox" type="radio" :value="rating" :name="name"
        v-model="value" :disabled="true" />★
    </span>
    {{value_text}}
  </div>
</template>

<script>
  import axios from 'axios'

  const COMPONENT_NAME = 'jx-rate'
  
  export default {
    name: COMPONENT_NAME,
    props: {
      'name': String,
      'value': null,
      'value_t': null,
      'value_text': null,
      'id': String,
      'disabled': Boolean,
      'required': Boolean,
      ratings: null,
      updateapi: String,
      snackbar: false,
      snackbarerror: false,
      pk: null,
      groupid: null
    },
    data () {
      return {
        temp_value: -1,
        value_t: -1,
        updateapi: '',
        loading: false
      }
    },
    methods: {
      star_over: function (index) {
        if (!this.disabled) {
          this.temp_value = this.ratings.indexOf(index)
          this.value_text = index
        }
      },
      /*
      * Behaviour of the stars on mouseout.
      */
      star_out: function () {
        if (!this.disabled) {
          this.temp_value = this.ratings[this.value]
        }
        this.value_text = this.value
      },
      /*
      * Set the rating of the score
      */
      set: function (value) {
        var vm = this
        vm.loading = true
        if (!vm.disabled) {
          // Make some call to a Laravel API using Vue.Resource
          vm.value_t = vm.ratings.indexOf(value)
          vm.value = value
          vm.value_text = value
          var currentRating = {
            value_t: vm.value_t,
            value: vm.value,
            value_text: vm.value_text,
            snackbar: false,
            snackbarerror: false
          }
          console.log(vm.updateapi)
          // CallAPI
          if (vm.updateapi != null) {
            vm.disabled = true
            const config = {
              headers: { 'groupId': vm.groupid }
            }
            console.log(vm.updateapi + '/' + vm.pk)
            axios.put(vm.updateapi + '/' + vm.pk, { }, config).then(function (response) {
              console.log('---> response put ')
              currentRating['snackbar'] = true
              vm.$emit('call-back-success', currentRating)
            })
            .catch(function (error) {
              console.log(error)
              currentRating['snackbarerror'] = false
              vm.$emit('call-back-error', currentRating)
            })
          }
        }
        setTimeout(function () {
          vm.loading = false
          vm.value_text = value
        }, 1000)
      }
    }
  }
</script>
