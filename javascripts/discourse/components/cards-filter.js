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

    if (params) {
      if (Object.keys(params).length === 0) {
        return true;
      } else {
        for (let param in params) {
          if (params[param]) {
            return false;
          } else {
            return true;
          }
        }
      }
    }
  },

  @discourseComputed("categories")
  includedCategories(categories) {
    let pluginCategories = this.siteSettings.docs_categories.split("|");

    let includedCategories;

    if (categories) {
      includedCategories = categories.filter((category) => {
        return pluginCategories.indexOf(`${category.id}`) !== -1;
      });
    }
    return includedCategories;
  },

  @discourseComputed("tags")
  includedTags(tags) {
    let pluginTags = this.siteSettings.docs_tags.split("|");

    let includedTags;

    if (tags) {
      includedTags = tags.filter((category) => {
        return pluginTags.indexOf(`${category.id}`) !== -1;
      });
    }

    return includedTags;
  },

  @discourseComputed()
  tagIcons() {
    let icons = {};

    settings.tag_icons.split("|").forEach((data) => {
      icons[data.split(",")[0]] = data.split(",")[1];
    });

    return icons;
  },

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
  },

  @discourseComputed()
  categoryOrders() {
    let order = {};

    settings.category_icons.split("|").forEach((data) => {
      const arrayData = data.split(",");
      if (arrayData.length === 3) {
        order[arrayData[0]] = arrayData[2];
      }
    });
    console.log(order);
    return order;
  },

  @discourseComputed()
  categoryIcons() {
    let icons = {};

    settings.category_icons.split("|").forEach((data) => {
      icons[data.split(",")[0]] = data.split(",")[1];
    });

    return icons;
  },
});
