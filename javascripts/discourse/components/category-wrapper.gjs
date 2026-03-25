/* eslint-disable ember/no-classic-components */
import Component from "@ember/component";
import { concat, hash } from "@ember/helper";
import { computed } from "@ember/object";
import { LinkTo } from "@ember/routing";
import { htmlSafe } from "@ember/template";
import { tagName } from "@ember-decorators/component";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";

@tagName("")
export default class CategoryWrapper extends Component {
  listOrder = ["title", "activity"];

  @computed("category")
  get categoryInfo() {
    return this.site.categories.findBy("id", this.category.id);
  }

  @computed("categoryIcons", "categoryInfo.id")
  get categoryIcon() {
    return this.categoryIcons[this.categoryInfo?.id];
  }

  @computed("categoryOrders", "categoryInfo.id")
  get order() {
    if (
      this.categoryOrders[this.categoryInfo?.id] &&
      this.categoryOrders[this.categoryInfo?.id].split("-").length > 0
    ) {
      if (
        this.listOrder.includes(
          this.categoryOrders[this.categoryInfo?.id]
            .split("-")[0]
            .trim()
            .toLowerCase()
        )
      ) {
        return this.categoryOrders[this.categoryInfo?.id]
          .split("-")[0]
          .trim()
          .toLowerCase();
      }
    }

    return null;
  }

  @computed("categoryOrders", "categoryInfo.id")
  get ascending() {
    if (
      this.categoryOrders[this.categoryInfo?.id] &&
      this.categoryOrders[this.categoryInfo?.id].split("-").length > 1
    ) {
      if (
        this.categoryOrders[this.categoryInfo?.id]
          .split("-")[1]
          .trim()
          .toLowerCase()
          .startsWith("a")
      ) {
        return true;
      }
    }

    return false;
  }

  @computed("categoryInfo.name")
  get categoryName() {
    return this.categoryInfo?.name;
  }

  @computed("categoryInfo.slug")
  get categorySlug() {
    return this.categoryInfo?.slug;
  }

  @computed("categoryInfo.description")
  get hasDescription() {
    return this.categoryInfo?.description && settings.category_description;
  }

  @computed("categoryInfo.description")
  get categoryDescription() {
    return this.categoryInfo?.description;
  }

  @computed("categoryInfo.color")
  get categoryColor() {
    return `#${this.categoryInfo?.color}`;
  }

  @computed("categoryInfo.topic_count")
  get hasTopics() {
    return this.categoryInfo?.topic_count >= 1;
  }

  @computed("categoryInfo.topic_count")
  get topicCount() {
    if (this.categoryInfo?.topic_count > 1) {
      return `${this.categoryInfo?.topic_count} ${i18n(themePrefix("topics"))}`;
    } else {
      return `${this.categoryInfo?.topic_count} ${i18n(themePrefix("topic"))}`;
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
