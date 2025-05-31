import Component from "@ember/component";
import { concat, hash } from "@ember/helper";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import { tagName } from "@ember-decorators/component";
import icon from "discourse/helpers/d-icon";
import htmlSafe from "discourse/helpers/html-safe";
import discourseComputed from "discourse/lib/decorators";
import { i18n } from "discourse-i18n";

@tagName("")
export default class CategoryWrapper extends Component {
  @service router;

  listOrder = ["title", "activity"];

  @discourseComputed("category")
  categoryInfo(category) {
    return this.site.categories.findBy("id", category.id);
  }

  @discourseComputed("categoryIcons", "categoryInfo.id")
  categoryIcon(icons, id) {
    return icons[id];
  }

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
  }

  @discourseComputed("categoryOrders", "categoryInfo.id")
  ascending(orders, id) {
    if (orders[id] && orders[id].split("-").length > 1) {
      if (orders[id].split("-")[1].trim().toLowerCase().startsWith("a")) {
        return true;
      }
    }

    return false;
  }

  @discourseComputed("categoryInfo.name")
  categoryName(categoryName) {
    return categoryName;
  }

  @discourseComputed("categoryInfo.slug")
  categorySlug(categorySlug) {
    return categorySlug;
  }

  @discourseComputed("categoryInfo.description")
  hasDescription(description) {
    return description && settings.category_description;
  }

  @discourseComputed("categoryInfo.description")
  categoryDescription(description) {
    return description;
  }

  @discourseComputed("categoryInfo.color")
  categoryColor(color) {
    return `#${color}`;
  }

  @discourseComputed("categoryInfo.topic_count")
  hasTopics(count) {
    return count >= 1;
  }

  @discourseComputed("categoryInfo.topic_count")
  topicCount(count) {
    if (count > 1) {
      return `${count} ${i18n(themePrefix("topics"))}`;
    } else {
      return `${count} ${i18n(themePrefix("topic"))}`;
    }
  }

  <template>
    <LinkTo
      @route="docs.index"
      @query={{hash
        category=this.category.id
        order=this.order
        ascending=this.ascending
      }}
      class="docs-card-box category-card card-{{this.categorySlug}}"
    >
      <div class="docs-card-box-header">
        {{#if this.categoryIcon}}
          {{icon this.categoryIcon}}
        {{else}}
          <span
            class="docs-card-box-header-badge-category-bg"
            style={{htmlSafe (concat "background-color: " this.categoryColor)}}
          ></span>
        {{/if}}
        <h3 class="docs-card-box-header-title">{{this.categoryName}}</h3>
      </div>

      {{#if this.hasDescription}}
        <p class="docs-card-box-description">{{htmlSafe
            this.categoryDescription
          }}</p>
      {{/if}}

      <span class="docs-card-box-count">{{this.topicCount}}</span>
    </LinkTo>
  </template>
}
