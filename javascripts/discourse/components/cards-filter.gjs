/* eslint-disable ember/no-classic-components, ember/require-tagless-components */
import Component from "@ember/component";
import { computed } from "@ember/object";
import { service } from "@ember/service";
import { classNameBindings } from "@ember-decorators/component";
import CategoryWrapper from "./category-wrapper";
import TagWrapper from "./tag-wrapper";

@classNameBindings("shouldShow:visible")
export default class CardsFilter extends Component {
  @service router;
  @service siteSettings;

  @computed("router.currentRoute.queryParams")
  get shouldShow() {
    if (!this.siteSettings.docs_enabled) {
      return false;
    }
    return this.includedCategories?.length > 0 || this.includedTags?.length > 0;
  }

  @computed("categories", "router.currentRoute.queryParams")
  get includedCategories() {
    let pluginCategories = this.siteSettings.docs_categories.split("|");
    let shownCategories;

    if (this.categories) {
      shownCategories = this.categories.filter((category) => {
        let currentCategory;

        if (this.router.currentRoute.queryParams?.category) {
          currentCategory =
            Number(this.router.currentRoute.queryParams?.category) ===
            category.id
              ? category.id
              : "";
        }

        return (
          pluginCategories.includes(`${category.id}`) &&
          currentCategory !== category.id
        );
      });
    }
    return shownCategories;
  }

  @computed("tags", "router.currentRoute.queryParams")
  get includedTags() {
    let pluginTags = this.siteSettings.docs_tags.split("|");
    let shownTags;

    if (this.tags) {
      shownTags = this.tags.filter((tag) => {
        let currentTags = [];

        if (this.router.currentRoute.queryParams?.tags) {
          currentTags.push(...this.router.currentRoute.queryParams.tags.split("|"));
        }

        return (
          pluginTags.includes(`${tag.name}`) && !currentTags.includes(tag.name)
        );
      });
    }

    return shownTags;
  }

  @computed()
  get tagIcons() {
    let icons = {};

    settings.tag_icons.split("|").forEach((data) => {
      icons[data.split(",")[0]] = data.split(",")[1];
    });

    return icons;
  }

  @computed()
  get tagOrders() {
    let order = {};

    settings.tag_icons.split("|").forEach((data) => {
      const arrayData = data.split(",");
      if (arrayData.length === 3) {
        order[arrayData[0]] = arrayData[2];
      }
    });

    return order;
  }

  @computed()
  get categoryOrders() {
    let order = {};

    settings.category_icons.split("|").forEach((data) => {
      const arrayData = data.split(",");
      if (arrayData.length === 3) {
        order[arrayData[0]] = arrayData[2];
      }
    });

    return order;
  }

  @computed()
  get categoryIcons() {
    let icons = {};

    settings.category_icons.split("|").forEach((data) => {
      icons[data.split(",")[0]] = data.split(",")[1];
    });

    return icons;
  }

  <template>
    <div class="docs-cards-filter">
      {{#if this.includedCategories}}
        {{#each this.includedCategories as |category|}}
          <CategoryWrapper
            @category={{category}}
            @categoryOrders={{this.categoryOrders}}
            @categoryIcons={{this.categoryIcons}}
            @updateSelectedCategory={{this.updateSelectedCategory}}
          />
        {{/each}}
      {{/if}}
      {{#if this.includedTags}}
        {{#each this.includedTags as |tag|}}
          <TagWrapper
            @tag={{tag}}
            @tagOrders={{this.tagOrders}}
            @tagIcons={{this.tagIcons}}
            @updateSelectedTag={{this.updateSelectedTag}}
          />
        {{/each}}
      {{/if}}
    </div>
  </template>
}
