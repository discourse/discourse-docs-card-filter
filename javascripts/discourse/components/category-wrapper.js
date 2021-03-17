import Component from "@ember/component";
import I18n from "I18n";
import discourseComputed from "discourse-common/utils/decorators";
import { action } from "@ember/object";

export default Component.extend({
  tagName: "",

  init() {
    this._super(...arguments);
  },

  @action
  selectCategory() {
    this.updateSelectedCategory(this.category)
  },

  @discourseComputed("category")
  categoryInfo(category) {
    return this.site.categories.findBy("id", category.id);
  },

  @discourseComputed("categoryIcons", "categoryInfo.id")
  categoryIcon(icons,id) {
    return icons[id];
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
    return description
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
})