Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518AA4EC71E
	for <lists+linux-bcache@lfdr.de>; Wed, 30 Mar 2022 16:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347230AbiC3Ovn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 30 Mar 2022 10:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347245AbiC3OvZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 30 Mar 2022 10:51:25 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573D21659D
        for <linux-bcache@vger.kernel.org>; Wed, 30 Mar 2022 07:49:39 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id y16so6582377ilc.7
        for <linux-bcache@vger.kernel.org>; Wed, 30 Mar 2022 07:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=S7jHDD9H3A3SYC5lPe9ohlnX79nRebzt30Q3Ep3X12o=;
        b=OZ3cEQ5h4qtPgX1AY6RLmB6gT57kvwRHQ79ygDaebLZjiOApKBgJvNSiNC+hGN40JU
         KFowpuzoi9RAMLTJX0fOxY1oyMHVZHloUrVLxLuOG/UlFNOYGVgGvwa2UU4emiJEzaf9
         q/b6t2EDuopDh+F9mdxQX6O8ADsK4gowwAsRa9RVPJ5GdcZXQj2mX6/QUQhRN12B8hnH
         NkupImYcQse6AfeDQRluWPm9O4lLIm1PCY+Y0ru6sks+rFgKWBzTtmSTEYxmLYKnRe/x
         TPd8nXiKZe260b1aynJD8YblWjvbxaX/g0RFrXX3pPqJAeiHYOnhcG7UGyHQwei5xlG9
         5gPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=S7jHDD9H3A3SYC5lPe9ohlnX79nRebzt30Q3Ep3X12o=;
        b=PeiZi2YTrnL4qI0+w6R8xBnOeuOZCNM9RRWz/zKnaxSMjKSTLQvczLLNUaAmx1fp9v
         naXRC+0hNhOVam/sWJBNP/PWSbTndQnqlwVJD+UAzHgr1cBkyrJqa1SMOYgCB6QZhKHl
         ZbG3Do/10zL//d/lLR6jyGWYjYTDHUibytzOaVD5JLt7CaiZMqYBykkEfYglEK3Wjl1H
         Z7VdSbKwFbw8USWxzbQEcGxqWkhNnjjsmXW87mpGv8sX0HSIHojzJ6N/huR+baVhipGI
         QySHvpNtV7lAO0nQKAEltnynFLBjX4XX92pYE5pAhix26UDFK2APRjkZOmD/GCQrkUGR
         qSjA==
X-Gm-Message-State: AOAM530uFdOUMXjTxEKwZPfrzNoAqGA24r69ENWRiR7vwNk5OhUF80xt
        AtRhfzm5s1nu7eDyapLs/ausiA==
X-Google-Smtp-Source: ABdhPJz3EibI69DwP9lkcaYHyRWrAtLzvk4HhXkWXzgIOSW08I0BfaQQag5PmpjZEv83Snk+VZv0fA==
X-Received: by 2002:a05:6e02:1e0e:b0:2c6:18c3:9691 with SMTP id g14-20020a056e021e0e00b002c618c39691mr11475070ila.287.1648651778718;
        Wed, 30 Mar 2022 07:49:38 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r9-20020a6b6009000000b006412abddbbbsm11434439iog.24.2022.03.30.07.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:49:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
        Coly Li <colyli@suse.de>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>,
        target-devel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org
In-Reply-To: <20220308061551.737853-1-hch@lst.de>
References: <20220308061551.737853-1-hch@lst.de>
Subject: Re: cleanup bio_kmalloc v2
Message-Id: <164865177761.37391.13379579175408786139.b4-ty@kernel.dk>
Date:   Wed, 30 Mar 2022 08:49:37 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, 8 Mar 2022 07:15:46 +0100, Christoph Hellwig wrote:
> this series finishes off the bio allocation interface cleanups by dealing
> with the weirdest member of the famility.  bio_kmalloc combines a kmalloc
> for the bio and bio_vecs with a hidden bio_init call and magic cleanup
> semantics.
> 
> This series moves a few callers away from bio_kmalloc and then turns
> bio_kmalloc into a simple wrapper for a slab allocation of a bio and the
> inline biovecs.  The callers need to manually call bio_init instead with
> all that entails and the magic that turns bio_put into a kfree goes away
> as well, allowing for a proper debug check in bio_put that catches
> accidental use on a bio_init()ed bio.
> 
> [...]

Applied, thanks!

[1/5] btrfs: simplify ->flush_bio handling
      commit: 6978ffddd5bba44e6b7614d52868cf4954e0529b
[2/5] squashfs: always use bio_kmalloc in squashfs_bio_read
      commit: 88a39feabf25efbaec775ffb48ea240af198994e
[3/5] target/pscsi: remove pscsi_get_bio
      commit: bbccc65bd7c1b22f050b65d8171fbdd8d72cf39c
[4/5] block: turn bio_kmalloc into a simple kmalloc wrapper
      commit: 57c47b42f4545b5f8fa288f190c0d68f96bc477f
[5/5] pktcdvd: stop using bio_reset
      commit: 1292fb59f283e76f55843d94f066c2f0b91dfb7e

Best regards,
-- 
Jens Axboe


