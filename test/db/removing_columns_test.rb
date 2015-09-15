require 'test_helper'

class WarnOnColumnRemovalTest < ActiveSupport::TestCase
  class RemovalWithoutDeprecation < ActiveRecord::Migration
    def change
      remove_column :about_pages, :read_more_link_text
    end
  end

  def test_remove_column_without_deprecation
    assert_output %r[WARNING: about_pages.read_more_link_text has not been deprecated] do
      ignoring_mysql_errors do
        RemovalWithoutDeprecation.new.change
      end
    end
  end

  class RemovalFromNonExistingTable < ActiveRecord::Migration
    def change
      remove_column :non_existing_table, :something
    end
  end

  def test_remove_column_from_non_existing_table
    assert_output %r[WARNING: Couldn't find model for table non_existing_table] do
      ignoring_mysql_errors do
        RemovalFromNonExistingTable.new.change
      end
    end
  end

  class RemovalFromTableWithDeprecation < ActiveRecord::Migration
    def change
      remove_column :about_pages, :name
    end
  end

  def test_remove_column_with_deprecation
    AboutPage.extend DeprecatedColumns
    AboutPage.deprecated_columns :name

    assert_output %r[OK: about_pages.name has been deprecated.] do
      ignoring_mysql_errors do
        RemovalFromTableWithDeprecation.new.change
      end
    end

    # Make sure we're back where we started.
    AboutPage.deprecated_column_list = []
  end

private

  def ignoring_mysql_errors
    begin
      yield
    rescue ActiveRecord::StatementInvalid
    end
  end
end
