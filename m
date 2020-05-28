Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4101E53BB
	for <lists+linux-bcache@lfdr.de>; Thu, 28 May 2020 04:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgE1CN3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 22:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgE1CN3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 22:13:29 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226B5C05BD1E
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 19:13:29 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id c8so7967185iob.6
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 19:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ztlJjgq919IbYuDLvbZQZJOPRCnJpn5WwWHj86nsT7M=;
        b=OBjOWcGsSs7nyRGtMVL+ZE+JB+98IHkfSu+eA7NV2OKfLfCdz2g0yRc8snsnwvssw0
         1LAuTAr1lE7RMficUXpBkFvOrXwQnS0K29ePUlFQKfIRwpOXIwLCGVdZCk6oCEypRHwl
         biNCwU38xnfu0Yeh/npw2uzUMSy7wtz9b/ZCNdvko20KBYwFAQHwooRZDEOztJidhYi3
         vowAluSh5/+lFDwscUTNUuA8ViI2Dz/30jMJLO41xS1NbzygjzpJqiCZfQwdzgo6NL0U
         gdwYY62vlenQNHS5yQ6guX7FCABeiWU/Ikah3VTBgajxmG4wVKiOAphMdMA92tMHDKf/
         E61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ztlJjgq919IbYuDLvbZQZJOPRCnJpn5WwWHj86nsT7M=;
        b=JD8/ac4BmiTsPbhFwnXtdVUI5hLyxZd96CtLqZVbFt0Ad4ktmbenFLP9PbVQ6Ky5XD
         12VpxLYMKJXJzxbSEaT7ITpgWojnNgLoF7AHacGy68Rb0UumHCGUFgOEe6crsIWQ9Sen
         rDuTtKMEaUzoomyR/n1sRste1WE+ABZiROrrrU6HPyNY7bk/l061/1VIok2/sy+tOj+a
         aAkyHMgWNPWEO8L7QCUfXAJNJj6czMjwlJpByqecTxQamgd/sq2eFO7f7slqSOOSPXAa
         t2siHBEifUXOyYSb98rB8DlnL/IGf1dPNm+mTF8EI+1Yv8QnrsKzswsSxTuWSXnRKT60
         H4Nw==
X-Gm-Message-State: AOAM530eA5i35ihYk5aerAuAiYzF5dnvJkTaWDPk6itiQjrJQqOT7NKS
        p4L1cmL3LXUT0pwj6ySPMCgpT7Fm9SuzkYJo5Wj1DyeA
X-Google-Smtp-Source: ABdhPJzZycRfapXhP2Pj+8OH5ujn16OMsa5rP0YMrjF60mNLZvoJullMXDpaOjutZmZgY+/lFVUUOe4haCCe3vfIWq8=
X-Received: by 2002:a05:6638:11c3:: with SMTP id g3mr761025jas.86.1590632008158;
 Wed, 27 May 2020 19:13:28 -0700 (PDT)
MIME-Version: 1.0
From:   Dongyang Zhan <zdyzztq@gmail.com>
Date:   Thu, 28 May 2020 10:13:21 +0800
Message-ID: <CAFSR4cuk8oXCYNCT7Tjoufv4bQQrEFSyZnOG0jTi-SqNKCd-xQ@mail.gmail.com>
Subject: Potential Memory Leak Bug in register_bcache() in Linux 5.6.0
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

My name is Dongyang Zhan, I am a security researcher.
Currently, I found a potential memory leak bug in register_bcache() of
drivers/md/bcache/super.c.
The allocated memory regions dc and ca will not be released when
register_cache() or register_bdev() fails.
I hope you can help me to confirm this bug.

The source code and comments are as follows.
https://elixir.bootlin.com/linux/v5.6/source/drivers/md/bcache/super.c#L2253

static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
      const char *buffer, size_t size)
{
...
struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
if (!dc)
    goto out_put_sb_page;

mutex_lock(&bch_register_lock);
ret = register_bdev(sb, sb_disk, bdev, dc);
mutex_unlock(&bch_register_lock);
/* blkdev_put() will be called in cached_dev_free() */
if (ret < 0)
    goto out_free_sb; // If ret <0, dc will not be released.
} else {
struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);

if (!ca)
    goto out_put_sb_page;

/* blkdev_put() will be called in bch_cache_release() */
if (register_cache(sb, sb_disk, bdev, ca) != 0)
    goto out_free_sb; // If it fails , ca will not be released.

out_put_sb_page:
put_page(virt_to_page(sb_disk));
out_blkdev_put:
blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
out_free_sb:
kfree(sb);
out_free_path:
kfree(path);
path = NULL;
out_module_put:
module_put(THIS_MODULE);
out:
pr_info("error %s: %s", path?path:"", err);
return ret;
}
