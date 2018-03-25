
<template>
    
    <div style="width: 100%;">  
      <h1>{{ locale_ }}</h1>
    <ul>
			<li v-lang.categories.posts></li>
			<li v-lang.categories.contact></li>
			<li v-lang.categories.about></li>
		</ul>
        <slot name="hay_lam" :locale_="locale_">
        </slot>
    </div>
</template>

<script>

const COMPONENT_NAME = 'jx-mobilink-language'

export default {
  name: COMPONENT_NAME,
    props : {
      locale_ : {
        type : String,
        default : 'en'
      }
    },
  components: {
  },
  created () {
    var vm = this
    vm.$nextTick(function () {
      console.log(">>>>>>>>>>>>>>>>>>>>>>>")
      alert(this.translate('title'))
    })
  },
  data() {
    return {
      myVariable: `I'm just a lonely old variable.`
    }
  },
  methods: {
    alertMe() {
      alert('parent alert me')
    },
    alertMe3() {
      alert('parent alert me 3')
    }
  }
}
</script>