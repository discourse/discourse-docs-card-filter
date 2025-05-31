import Component from "@ember/component";
import { service } from "@ember/service";
import { classNameBindings } from "@ember-decorators/component";
import discourseComputed from "discourse/lib/decorators";
import CategoryWrapper from "./category-wrapper";
import TagWrapper from "./tag-wrapper";

@classNameBindings("shouldShow:visible")
export default class CardsFilter extends Component {
  @service router;

  @discourseComputed("router.currentRoute.queryParams")
  shouldShow() {
    if (!this.siteSettings.docs_enabled) {
      return false;
    }
    return this.includedCategories?.length > 0 || this.includedTags?.length > 0;
  }

  @discourseComputed("categories", "router.currentRoute.queryParams")
  includedCategories(categories, params) {
    let pluginCategories = this.siteSettings.docs_categories.split("|");

    let shownCategories;

    if (categories) {
      shownCategories = categories.filter((category) => {
        let currentCategory;

        if (params?.category) {
          currentCategory =
            Number(params.category) === category.id ? category.id : "";
        }

        return (
          pluginCategories.includes(`${category.id}`) &&
          currentCategory !== category.id
        );
      });
    }
    return shownCategories;
  }

  @discourseComputed("tags", "router.currentRoute.queryParams")
  includedTags(tags, params) {
    let pluginTags = this.siteSettings.docs_tags.split("|");

    let shownTags;

    if (tags) {
      shownTags = tags.filter((tag) => {
        let currentTags = [];

        if (params?.tags) {
          currentTags.push(...params.tags.split("|"));
        }

        return (
          pluginTags.includes(`${tag.id}`) && !currentTags.includes(tag.id)
        );
      });
    }

    return shownTags;
  }

  @discourseComputed()
  tagIcons() {
    let icons = {};

    settings.tag_icons.split("|").forEach((data) => {
      icons[data.split(",")[0]] = data.split(",")[1];
    });

    return icons;
  }

  @discourseComputed()
  tagOrders() {
    let order = {};

    settings.tag_icons.split("|").forEach((data) => {
      const arrayData = data.split(",");
      if (arrayData.length === 3) {
        order[arrayData[0]] = arrayData[2];
      }
    });

    return order;
  }

  @discourseComputed()
  categoryOrders() {
    let order = {};

    settings.category_icons.split("|").forEach((data) => {
      const arrayData = data.split(",");
      if (arrayData.length === 3) {
        order[arrayData[0]] = arrayData[2];
      }
    });

    return order;
  }

  @discourseComputed()
  categoryIcons() {
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
