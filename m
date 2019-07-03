Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745ED5D8A1
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jul 2019 02:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfGCA0l (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 20:26:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40800 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGCA0k (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 20:26:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so218242pgj.7;
        Tue, 02 Jul 2019 17:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G2YqfkEvAQAEaHiI4AbuUSgjkEW4+tXLhh4WWMs6JGc=;
        b=tizq4CrVTABFZl6lnMuMEVk6tKI1qJnrWGFe4D/LjmvB+V/tTxAnsgpyrZ8ifIyQMT
         DeSjjLtTF+MYi9fu+Udh57TbTdSonKNX1fyQwjbtUsQ1mNxyYGZ0tOg7kdONrRwWYHRU
         /81FIsGttSimYEFso4N+gs0xCCAPgOYT7desTo5Us0nvxbySoSFC5NjbJlBLCdASlvYe
         Z+BerYub+aib38bjlte4Y2MPUytGx4mmaBBg24mm2Se4RN4gJJ/BwU8sdjhBPIqh0JjG
         vO+YziBW9IDARDb2dlpWDmQmaMHMRdAKP9RusLrskr5Z+0YQY4lT5v/jU4vBxDvMKwVO
         ynBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=G2YqfkEvAQAEaHiI4AbuUSgjkEW4+tXLhh4WWMs6JGc=;
        b=YcHjJbAoBwDOL91jJCesHPC+ll8kDFpBgsA2kdJsBTnplL3cuTZa9q18eiUdxRh71r
         GoK4ciKg9u++p+g0i/hCwv7veIlbTKx1LnMlcsNppewnlhqzdtF58/shW7QUtFfijZa3
         ZYWhc1XyGw8kOtC+pAvZb4XlCgotull7+GIVOtGVYzWYBQ5wNxc/I5x04ftOMDRaD6m3
         rFU3O4gl3h1qD1W28l3y9ZOLVDMelAARSh9/5OX8xAJMrFwjY8yANMJrg06WkGFKZe/c
         j2a61MopcbUMdiWey3LOK10cDOGK6R9hemWuivB9rp7sER4riDpMfXY48rR3JldH8Pk/
         HXww==
X-Gm-Message-State: APjAAAUGeytt7k7Ag4ies8iP4HBUz0oc/0POnehYsOLM8sL9w2Li/kVx
        Jusd2/WjPuN60LYcaWHYGO8=
X-Google-Smtp-Source: APXvYqy+IWFwh62Asy5np8pkDyBI/cyqwDN82970y6xL03Sfn32ecxy0iA6/KhMffPZM6PpjIKF3hg==
X-Received: by 2002:a17:90a:1785:: with SMTP id q5mr8609557pja.106.1562113148665;
        Tue, 02 Jul 2019 17:19:08 -0700 (PDT)
Received: from localhost ([123.213.206.190])
        by smtp.gmail.com with ESMTPSA id y5sm246107pgv.12.2019.07.02.17.19.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 17:19:07 -0700 (PDT)
Date:   Wed, 3 Jul 2019 09:19:04 +0900
From:   Minwoo Im <minwoo.im.dev@gmail.com>
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc:     linux-block@vger.kernel.org, colyli@suse.de,
        linux-bcache@vger.kernel.org, linux-btrace@vger.kernel.org,
        xen-devel@lists.xenproject.org, kent.overstreet@gmail.com,
        yuchao0@huawei.com, jaegeuk@kernel.org, damien.lemoal@wdc.com,
        konrad.wilk@oracle.com, roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V3 1/9] block: add a helper function to read nr_setcs
Message-ID: <20190703001904.GB15705@minwoo-desktop>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 19-07-02 10:42:27, Chaitanya Kulkarni wrote:
> This patch introduces helper function to read the number of sectors
> from struct block_device->bd_part member. For more details Please refer
> to the comment in the include/linux/genhd.h for part_nr_sects_read().

Without bd_mutex locked, this helper seems useful to have.

Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
