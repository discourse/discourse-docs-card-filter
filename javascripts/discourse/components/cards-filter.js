import Component from "@ember/component";
import { withPluginApi } from "discourse/lib/plugin-api";
import { inject as service } from "@ember/service";
import discourseComputed from "discourse-common/utils/decorators";
import { readOnly } from "@ember/object/computed";

export default Component.extend({
  classNameBindings: ["shouldShow:visible"],
  router: service(),
  init() {
    this._super(...arguments);
  },

  @discourseComputed("router.currentRoute.queryParams")
  shouldShow(params) {
    if (!this.siteSettings.docs_enabled) return false;
    return this.includedCategories?.length > 0 || this.includedTags?.length > 0 || this.includedCustomQueries?.length > 0;
  },

  @discourseComputed("categories", "router.currentRoute.queryParams")
  includedCategories(categories, params) {
    let pluginCategories = this.siteSettings.docs_categories.split("|");

    let shownCategories;

    if (categories) {
      shownCategories = categories.filter(category => {
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
  },

  @discourseComputed("tags", "router.currentRoute.queryParams")
  includedTags(tags, params) {
    let pluginTags = this.siteSettings.docs_tags.split("|");

    let shownTags;

    if (tags) {
      shownTags = tags.filter(tag => {
        let currentTags = [];

        if (params?.tags) {
          currentTags.push(...params.tags.split("|"));
        }

        return (
          pluginTags.includes(`${tag.id}`) &&
          !currentTags.includes(tag.id)
        );
      });
    }

    return shownTags;
  },

  @discourseComputed()
  includedCustomQueries() {
    let customQArray = [];

    settings.custom_queries.split("|").forEach(customQ => {
      try {
        let entry = {}

        console.log(customQ)
        console.log(typeof customQ)
        const formattedCustomQ = JSON.parse(customQ)

        if (formattedCustomQ.category) entry.category = formattedCustomQ.category
        if (formattedCustomQ.tags) entry.tags = formattedCustomQ.tags
        if (formattedCustomQ.name) entry.name = formattedCustomQ.name

        customQArray.push(entry)
      } catch (err) {
        console.log(err.message)
      }
    });
    console.log(customQArray)
    return customQArray
  },

  @discourseComputed()
  tagIcons() {
    let icons = {};

    settings.tag_icons.split("|").forEach(data => {
      icons[data.split(",")[0]] = data.split(",")[1];
    });

    return icons;
  },

  @discourseComputed()
  tagOrders() {
    let order = {};

    settings.tag_icons.split("|").forEach(data => {
      const arrayData = data.split(",");
      if (arrayData.length === 3) {
        order[arrayData[0]] = arrayData[2];
      }
    });

    return order;
  },

  @discourseComputed()
  categoryOrders() {
    let order = {};

    settings.category_icons.split("|").forEach(data => {
      const arrayData = data.split(",");
      if (arrayData.length === 3) {
        order[arrayData[0]] = arrayData[2];
      }
    });

    return order;
  },

  @discourseComputed()
  categoryIcons() {
    let icons = {};

    settings.category_icons.split("|").forEach(data => {
      icons[data.split(",")[0]] = data.split(",")[1];
    });

    return icons;
  }
});
