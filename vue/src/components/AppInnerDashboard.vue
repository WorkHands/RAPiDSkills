<template>
  <div class="app__inner--dashboard">
    <div class="app__inner--dashboard__body" id="body">
      <div class="app__inner--dashboard__body__content">
        <router-view />
      </div>
      <div class="app__inner--dashboard__body__sidebar--right">
        <div class="app__inner--dashboard__body__sidebar--right__section">
          <SidebarSectionFAQ />
        </div>
      </div>
    </div>
    <div class="app__inner--dashboard__nav--top">
      <router-link class="app__inner--dashboard__nav--top__link app__inner--dashboard__nav--top__link--logo" :to="{ name: 'home' }">
        <img :src="LOGO_ALT_FULL_NO_ICON" alt="RapidSkills Logo" class="app__inner--dashboard__nav--top__link--logo__logo" />
      </router-link>
      <div class="app__inner--dashboard__nav--top__navbar-actions" :class="{ 'app__inner--dashboard__nav--top__navbar-actions--session-active': sessionActive }">
        <router-view name="navbarActions" />
      </div>
      <!-- <a class="app__inner--dashboard__nav--top__link app__inner--dashboard__nav--top__link--support" href="javascript:void(0)">
        <img :src="ICON_TOP_NAV_SUPPORT" alt="Support Icon" class="app__inner--dashboard__nav--top__link__icon" />
      </a> -->
      <a class="app__inner--dashboard__nav--top__link app__inner--dashboard__nav--top__link--user" href="javascript:void(0)" v-if="sessionActive" @click="toggleUserOpen">
        <div class="app__inner--dashboard__nav--top__link--user__button">
          {{ userInitials }}
        </div>
        <div class="app__inner--dashboard__nav--top__link--user__dropdown" v-if="userOpen">
          <router-link class="app__inner--dashboard__nav--top__link--user__dropdown__item" href="javascript:void(0)" :to="{ name: 'signout' }">
            Sign out
          </router-link>
        </div>
      </a>
    </div>
    <div class="app__inner--dashboard__nav--left">
      <a class="app__inner--dashboard__nav--left__link app__inner--dashboard__nav--left__link--icon" href="javascript:void(0)">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_WHITE" alt="RapidSkills White Icon" class="app__inner--dashboard__nav--left__link--icon__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <img :src="LOGO_ALT_FULL_NO_ICON_WHITE" alt="RapidSkills Logo White" class="app__inner--dashboard__nav--left__link__name__logo" />
        </span>
      </a>
      <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'standards' }" active-class="app__inner--dashboard__nav--left__link--active">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_DASHBOARD" alt="Dashboard Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Home
          </span>
        </span>
      </router-link>
      <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'saved' }" active-class="app__inner--dashboard__nav--left__link--active" v-if="sessionActive">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <FontAwesomeIcon :icon="['fas', 'file-alt']" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon--fa" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            My Work Schedules
          </span>
        </span>
      </router-link>
      <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'favorites' }" active-class="app__inner--dashboard__nav--left__link--active" v-if="sessionActive">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_HEART" alt="Saved Work Schedules Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Favorites
          </span>
        </span>
      </router-link>
      <a class="app__inner--dashboard__nav--left__link" target="_blank" href="https://rapidskillsgenerator.zendesk.com/hc/en-us/sections/360009797231-Work-process-schedules-explained">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon">
            <FontAwesomeIcon :icon="['fas', 'info']" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon--fa app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon--info" />
          </span>
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            How To
          </span>
        </span>
      </a>
      <a class="app__inner--dashboard__nav--left__link" target="_blank" href="https://rapidskillsgenerator.zendesk.com/hc/en-us">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon">
            <FontAwesomeIcon :icon="['fas', 'question-circle']" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon--fa" />
          </span>
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Help
          </span>
        </span>
      </a>
      <!-- <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'reports' }" active-class="app__inner--dashboard__nav--left__link--active" v-if="sessionActive">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_PIE_CHART" alt="Reports Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Reports
          </span>
        </span>
      </router-link>
      <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'settings' }" active-class="app__inner--dashboard__nav--left__link--active" v-if="sessionActive">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_SETTINGS" alt="Settings Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Settings
          </span>
        </span>
      </router-link> -->
      <div class="app__inner--dashboard__nav--left__legal-links">
        <router-link class="app__inner--dashboard__nav--left__link app__inner--dashboard__nav--left__link--legal" to="about">
          <span class="app__inner--dashboard__nav--left__link__name">
            <span class="app__inner--dashboard__nav--left__link__name__text">
              About Us
            </span>
          </span>
        </router-link>
        <router-link class="app__inner--dashboard__nav--left__link app__inner--dashboard__nav--left__link--legal app__inner--dashboard__nav--left__link--legal--first" to="terms">
          <span class="app__inner--dashboard__nav--left__link__name">
            <span class="app__inner--dashboard__nav--left__link__name__text">
              Terms {{ '&' }} Conditions
            </span>
          </span>
        </router-link>
        <router-link class="app__inner--dashboard__nav--left__link app__inner--dashboard__nav--left__link--legal" to="privacy">
          <span class="app__inner--dashboard__nav--left__link__name">
            <span class="app__inner--dashboard__nav--left__link__name__text">
              Privacy Policy
            </span>
          </span>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script scoped lang="ts">
import Vue from 'vue';
import {
  Component, Provide,
} from 'vue-property-decorator';

import SidebarSectionFAQ from '@/components/SidebarSectionFAQ.vue';

import ICON_WHITE from '@/assets/icon-white.svg';
import ICON_LEFT_NAV_DASHBOARD from '@/assets/left-nav-icon-dashboard.svg';
import ICON_LEFT_NAV_HEART from '@/assets/left-nav-icon-heart.svg';
import ICON_LEFT_NAV_PIE_CHART from '@/assets/left-nav-icon-pie-chart.svg';
import ICON_LEFT_NAV_SETTINGS from '@/assets/left-nav-icon-settings.svg';
import LOGO_ALT_FULL_NO_ICON from '@/assets/logo-alt-full-no-icon.svg';
import LOGO_ALT_FULL_NO_ICON_WHITE from '@/assets/logo-alt-full-no-icon-white.svg';
import ICON_TOP_NAV_SUPPORT from '@/assets/top-nav-icon-support.svg';

@Component({
  components: {
    SidebarSectionFAQ,
  },
})
export default class AppInnerDashboard extends Vue {
  @Provide('ICON_WHITE') ICON_WHITE = ICON_WHITE

  @Provide('ICON_LEFT_NAV_DASHBOARD') ICON_LEFT_NAV_DASHBOARD = ICON_LEFT_NAV_DASHBOARD

  @Provide('ICON_LEFT_NAV_HEART') ICON_LEFT_NAV_HEART = ICON_LEFT_NAV_HEART

  @Provide('ICON_LEFT_NAV_PIE_CHART') ICON_LEFT_NAV_PIE_CHART = ICON_LEFT_NAV_PIE_CHART

  @Provide('ICON_LEFT_NAV_SETTINGS') ICON_LEFT_NAV_SETTINGS = ICON_LEFT_NAV_SETTINGS

  @Provide('LOGO_ALT_FULL_NO_ICON') LOGO_ALT_FULL_NO_ICON = LOGO_ALT_FULL_NO_ICON

  @Provide('LOGO_ALT_FULL_NO_ICON_WHITE') LOGO_ALT_FULL_NO_ICON_WHITE = LOGO_ALT_FULL_NO_ICON_WHITE

  @Provide('ICON_TOP_NAV_SUPPORT') ICON_TOP_NAV_SUPPORT = ICON_TOP_NAV_SUPPORT

  userOpen: boolean = false

  toggleUserOpen() {
    this.userOpen = !this.userOpen;
  }

  protected get userInitials() {
    return this.$store.getters['user/initials'];
  }

  protected get sessionActive() {
    return this.$store.getters['session/isActive'];
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/mixins";
@import "@/scss/colors";
@import "@/scss/navbars";
@import "@/scss/dashboard";

.app__inner--dashboard__nav--top,
.app__inner--dashboard__nav--left,
.app__inner--dashboard__body {
  position: fixed;
}

.app__inner--dashboard__nav--top,
.app__inner--dashboard__nav--left {
  display: flex;
}

.app__inner--dashboard__nav--top {
  top: 0;
  left: $nav-left-width;
  right: 0;
  height: $nav-top-height;
  background: $color-white;
  box-shadow: $color-nav-bar-top-box-shadow 0px 4px 32px 1px;
  flex-direction: row;
  align-content: space-between;
}

.app__inner--dashboard__nav--top__navbar-actions {
  display: flex;
  flex-basis: auto;
  align-self: center;
  flex-grow: 1;
  justify-content: center;
  padding-left: 0.5rem;
  padding-right: 0.5rem;
  max-width: calc(100% - 4rem);
  &.app__inner--dashboard__nav--top__navbar-actions--session-active {
    max-width: calc(100% - 8.0625rem - 5.5rem);
    @include breakpoint--sm {
      max-width: calc(100% - 4.0625rem);
    }
  }
}

.app__inner--dashboard__nav--top__link {
  display: flex;
  height: $nav-top-height;
  justify-content: center;
  padding: 0 $nav-top-link-padding-sides;
  &:hover {
    background: transparentize($color: $color-black, $amount: 0.98);
  }
}

.app__inner--dashboard__nav--top__link--logo {
  min-width: 9.5rem;
  align-self: flex-start;
  flex-basis: 0;

  @include breakpoint--sm {
    display: none;
  }
}

.app__inner--dashboard__nav--top__link--support {
  align-self: flex-end;
}

.app__inner--dashboard__nav--top__link__icon {
  width: 2rem;
}

.app__inner--dashboard__nav--left {
  top: 0;
  bottom: 0;
  left: 0;
  width: $nav-left-width;
  height: 100vh;
  background: $color-nav-left-background-blue;
  flex-direction: column;
  align-content: flex-start;
  transition: width 0.25s ease;
  overflow-x: hidden;
  padding-bottom: 2rem;

  &:hover {
    width: $nav-left-width-expanded;
  }
}

.app__inner--dashboard__nav--left__link {
  display: flex;
  height: $nav-top-height;
  justify-content: flex-start;
  opacity: 0.5;

  &:hover {
    background: $color-black-darkened;
  }
}

.app__inner--dashboard__nav--left__link--legal {
    padding-left: .75rem;
    padding-right: .25rem;

    .app__inner--dashboard__nav--left__link__name {
      font-size: 1rem;
      text-align: left;
      line-height: $nav-top-height;
      width: 100%;
      overflow: hidden;
      text-overflow: ellipsis;
      display: block;
    }
  }

.app__inner--dashboard__nav--left__legal-links {
  margin-top: auto;
}

.app__inner--dashboard__nav--left__link--icon__icon {
  width: 1.125rem;
}

.app__inner--dashboard__nav--left__link--icon__icon-wrapper {
  display: flex;
  justify-content: center;
  height: 100%;
  width: $nav-left-width;
}

.app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon {
  color: $color-white;
  width: 1.5rem;
}

.app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon--text {
  font-size: 1.5rem;
  line-height: 4rem;
}

.app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon--fa {
  height: 100%;
  width: 1.333rem;
}

.app__inner--dashboard__nav--left__link--active {
  opacity: 1;
}

.app__inner--dashboard__nav--left__link--icon {
  opacity: 1;
  background: $color-blue;

  &:hover {
    background: $color-blue-darkened;
  }
}

.app__inner--dashboard__nav--left__link__name {
  display: flex;
  align-items: center;
  height: 100%;
  color: $color-white;
  width: 0;
  overflow: visible;
  white-space: nowrap;
  font-weight: 500;
}

.app__inner--dashboard__nav--left__link__name__logo {
  padding-left: $nav-top-link-padding-sides;
}

.app__inner--dashboard__body {
  display: flex;
  top: $nav-top-height;
  left: $nav-left-width;
  min-width: calc(100vw - #{$nav-left-width});
  min-height: calc(100vh - #{$nav-top-height});
  right: 0;
  bottom: 0;
  overflow: auto;
}

.app__inner--dashboard__body__content {
  position: relative;
  min-height: 100%;
  padding-bottom: $dashboard-body-content-bottom-padding;
  flex-grow: 1;
}

.app__inner--dashboard__nav--top__link--user {
  align-self: flex-end;
  position: relative;
  padding: 0.75rem;
  border-left: 1px solid $color-gray-light;
}

.app__inner--dashboard__nav--top__link--user__button {
  height: 2.5rem;
  width: 2.5rem;
  border-radius: 50%;
  color: $color-white;
  background-color: $color-blue;
  font-weight: 600;
  line-height: 2.5rem;
}

.app__inner--dashboard__nav--top__link--user__dropdown {
  position: absolute;
  top: 100%;
  right: 0;
  background: $color-white;
  width: 8rem;
  border: 1px solid $color-gray-light;
  overflow: hidden;
  border-radius: 4px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}

.app__inner--dashboard__nav--top__link--user__dropdown__item {
  display: block;
  padding: .5rem;
  text-align: center;
  color: $color-black;
  font-weight: 500;
  &:not(:last-child) {
    border-bottom: 1px solid $color-gray-light;
  }

  &:hover {
    background: darken($color: $color-white, $amount: 10);
  }
}

.app__inner--dashboard__body__sidebar--right {
  padding: 2rem;
  width: $dashboard-sidebar-right-width;
  flex-shrink: 0;
  border-left: 1px solid $color-gray-border;

  @include breakpoint--lg {
    display: none;
  }
}

.app__inner--dashboard__body__sidebar--right__section {
  width: 100%;

  background: $color-white;
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.06), 0px 0px 1px rgba(0, 0, 0, 0.02);
  border-radius: 3px;
}

.app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon--info {
  padding-top: 1.25rem;
  padding-bottom: 1.25rem;
}
</style>
