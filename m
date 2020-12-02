Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE812CCA68
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 00:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgLBXRH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 18:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbgLBXRH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 18:17:07 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C35FC0613D6;
        Wed,  2 Dec 2020 15:16:27 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id v143so484802qkb.2;
        Wed, 02 Dec 2020 15:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EeuwLeoomrRX1U6jiimxDGdm+UmMVxu8rCoS4eNDoAg=;
        b=lyEozf2kC4oJa1iJ6Uh7kk8rM/7Sw6j168OF3aDlVU9syc9L60bKuA7w4AFVPoEBvV
         Qq818wm95DwK8S1HA8ZWHx24ioWu4j4mn2b5gm6xHlDmr4yq4csaQNdtydVCzE6nxzYk
         L/DQILk0TMPgedVMX1MVC8DJEs7RI/EDACNHQAa1uBXoAwoRPxbkwnFpRra361kLhDJt
         RHULUDVC+YENZpwsx8bSgSfsSAjrS8hmBaecI8b65d6Ays6ArZ3qsRrljRCjHFQBte2M
         BUrXXp70j5yjH8oQpMeKFtv4ij2NVQNnXhie46lH5AhOibPMC92ETyfhu2lhvwA53bvM
         wofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=EeuwLeoomrRX1U6jiimxDGdm+UmMVxu8rCoS4eNDoAg=;
        b=Vq6WYrNNyoVAMBuYSzVZjBDlAAEmEfnLtFuM5Bmp0EhPLSixTGrCP3loDlhNwL+G/J
         IPgOLEs3If0fr+whntFSVFx6WVKf5TUf0f8ald7EbUKqJtqldxQTjUg4HL0+d0yhkToq
         0X4uYc17GOFhOttGCjK0Yt8RUJ9EwJTnKNgZKewk7xZ7rzHiSM8q8vqCkjZE3hzGJR/u
         fmVAWOdw3aKPzmVjUFqAfEwvJBmsPiO2tEmB+WvkQ1gyNg2qcJrgGyz9g3/WMcAS8Eai
         wHXQyVsNazchMOqOvWgKpGbyYOXmZNtlEIdHwTqkFjEvq75CAQOwRo/gAN/tazCw0xU6
         ZD0Q==
X-Gm-Message-State: AOAM533u74DpevwLXUyBECTt1O/ROb7/1+6BY26V2ZukjHODlOz2WehF
        clXsCqeymp4X1Yrk9fUIZ1UBYsWC8OFYNg==
X-Google-Smtp-Source: ABdhPJw74aI5NUv2CAvLU/CD9FKcox1VupQf9vmhaG7IqRQi0hDXcbQvftKzKEPArmc+kjavi+g65w==
X-Received: by 2002:a05:620a:164b:: with SMTP id c11mr135922qko.203.1606950986443;
        Wed, 02 Dec 2020 15:16:26 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id p62sm149702qkf.50.2020.12.02.15.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 15:16:25 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 18:15:57 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 8/9] block: remove DISK_PITER_REVERSE
Message-ID: <X8ggLXsNOCh6Mrj0@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-9-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:23PM +0100, Christoph Hellwig wrote:
> There is good reason to iterate backwards when deleting all partitions in
> del_gendisk, just like we don't in blk_drop_partitions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, I was blindly keeping the iteration order. Can't find any explicit
explanation why it was that way. The reverse iteration there goes back to
the initial git import. But yeah, I can't think of any meaningful difference
which can come out of it.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
