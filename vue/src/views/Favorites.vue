<template>
  <div class="page page--favorites">
    <div class="page__header">
      <div class="page__header__title">
        Favorites
      </div>
      <div class="page__header__subtitle">
        Favorites contains any of the work schedules you've saved for later by clicking on the heart icon. These are not customizable but available for easy access if you want to customize later.
      </div>
    </div>
    <div class="page--favorites__cards" v-if="!showLoadingState">
      <Standard v-for="standard in standards" :standard="standard" :key="standard.id" :label="standard.occupationKind" saved />
    </div>
    <div class="page--favorites__state--loading" v-if="showLoadingState">
      <Loading />
    </div>
    <div class="page--favorites__state--empty" v-if="showEmptyState">
      No favorites found.
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component,
} from 'vue-property-decorator';

import Standard from '@/components/Standard.vue';
import Loading from '@/components/Loading.vue';

@Component({
  components: {
    Standard,
    Loading,
  },
})
export default class Favorites extends Vue {
  protected get showEmptyState() {
    return !this.showLoadingState && !this.standards.length;
  }

  protected get showLoadingState() {
    return this.$store.state.user.favoritesLoading;
  }

  protected get standards() {
    return this.$store.state.user.favorites || [];
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/page";
@import "@/scss/mixins";
@import "@/scss/standards";
@import "@/scss/navbars";

.page--favorites__cards {
  @extend .standard-cards;
}

.page--favorites__state--empty {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 5rem;
}
</style>
