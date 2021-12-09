import Component from "@ember/component";
import I18n from "I18n";
import discourseComputed from "discourse-common/utils/decorators";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default Component.extend({
  router: service(),
  tagName: "",
  listOrder: ["title", "activity"],

  init() {
    this._super(...arguments);
  },

  @action
  selectCategory() {
    this.get("router").transitionTo("docs.index", {
      queryParams: {
        category: this.category.id,
        order: this.order,
        ascending: this.ascending,
      },
    });
  },

  @discourseComputed("category")
  categoryInfo(category) {
    return this.site.categories.findBy("id", category.id);
  },

  @discourseComputed("categoryIcons", "categoryInfo.id")
  categoryIcon(icons, id) {
    return icons[id];
  },

  @discourseComputed("categoryOrders", "categoryInfo.id")
  order(orders, id) {
    if (orders[id] && orders[id].split("-").length > 0) {
      if (
        this.listOrder.includes(orders[id].split("-")[0].trim().toLowerCase())
      ) {
        return orders[id].split("-")[0].trim().toLowerCase();
      }
    }

    return null;
  },

  @discourseComputed("categoryOrders", "categoryInfo.id")
  ascending(orders, id) {
    if (orders[id] && orders[id].split("-").length > 1) {
      if (orders[id].split("-")[1].trim().toLowerCase().startsWith("a")) {
        return true;
      }
    }

    return false;
  },

  @discourseComputed("categoryInfo.name")
  categoryName(categoryName) {
    return categoryName;
  },

  @discourseComputed("categoryInfo.description")
  hasDescription(description) {
    return description && settings.category_description;
  },

  @discourseComputed("categoryInfo.description")
  categoryDescription(description) {
    return description;
  },

  @discourseComputed("categoryInfo.color")
  categoryColor(color) {
    return `#${color}`;
  },

  @discourseComputed("categoryInfo.topic_count")
  hasTopics(count) {
    return count >= 1;
  },

  @discourseComputed("categoryInfo.topic_count")
  topicCount(count) {
    if (count > 1) {
      return `${count} ${I18n.t(themePrefix("topics"))}`;
    } else {
      return `${count} ${I18n.t(themePrefix("topic"))}`;
    }
  },
});
