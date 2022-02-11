import Component from "@ember/component";
import I18n from "I18n";
import discourseComputed from "discourse-common/utils/decorators";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default Component.extend({
  router: service(),
  tagName: "",

  init() {
    this._super(...arguments);
  },

  @action("includedCustomQueries")
  selectCustomQuery(customQ) {
    this.get("router").transitionTo("docs.index", {
      queryParams: {
        category: customQ.category,
        tags: customQ.tags,
        // order: this.order,
        // ascending: this.ascending,
      },
    });
  },

  @discourseComputed(/*"tagOrders", "tag.id"*/)
  order(/*orders, id*/) {
    /*if (orders[id] && orders[id].split("-").length > 0) {
      if (
        this.listOrder.includes(orders[id].split("-")[0].trim().toLowerCase())
      ) {
        return orders[id].split("-")[0].trim().toLowerCase();
      }
    }*/

    return null;
  },

  @discourseComputed(/*"tagOrders", "tag.id"*/)
  ascending(/*orders, id*/) {
    /*if (orders[id] && orders[id].split("-").length > 1) {
      if (orders[id].split("-")[1].trim().toLowerCase().startsWith("a")) {
        return true;
      }
    }*/

    return false;
  },

  @discourseComputed("tagIcons", "tag.id")
  tagIcon(tagIcons, id) {
    return tagIcons[id];
  },

  @discourseComputed("tag.id")
  tagTitle(tagTitle) {
    return tagTitle;
  },

  @discourseComputed("tag")
  hasTopics(tag) {
    return tag.count >= 1;
  },

  @discourseComputed("tag.count")
  topicCount(count) {
    if (count > 1) {
      return `${count} ${I18n.t(themePrefix("topics"))}`;
    } else {
      return `${count} ${I18n.t(themePrefix("topic"))}`;
    }
  },
});
