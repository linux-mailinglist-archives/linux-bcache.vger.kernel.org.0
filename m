Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C264364EA
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Oct 2021 17:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhJUPD2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 21 Oct 2021 11:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbhJUPDZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 21 Oct 2021 11:03:25 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE10AC061243
        for <linux-bcache@vger.kernel.org>; Thu, 21 Oct 2021 08:01:09 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id t4so1202554oie.5
        for <linux-bcache@vger.kernel.org>; Thu, 21 Oct 2021 08:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=6jnVZbBkLbnw6pFZpxUldRg4FuFfEZElhVVQao3Uy20=;
        b=ZGFMo833ta2HUfgqVLXUNHJV5pTUNb23BosrQDRrArzz1VYW1rZvujqd1q9AvwL/2L
         I3qasTS/LaOX+rTG38fA1WkYeozE1AIG6Y1LWW3KJy++pLKzaue+ysn5BR5qqBazSL3X
         IVR4Fjt0Mg/h6j4Zo8LPwJHvk9rRXi+EODiN4CZjW0a3nWKAwsxdaWUyN0Iinpv2NO0m
         dB+Q+OGRW5ZAtyv3ynB4fi22vLxF+kmJ+bRRxyM9NM8BrnQaDlNccb6EwaqBPSB/5dXE
         w0UzuwJbGrVM1iqd9niPDqAPfBdtIGPYSTrtcyZITTG5mzlvKTmg+/w7FrEp4Vj/y3G+
         Cdig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=6jnVZbBkLbnw6pFZpxUldRg4FuFfEZElhVVQao3Uy20=;
        b=o+GUPxpGjb73Da/bAqZCifqNxI4mMMveZ/9sWE0II2mDTU6KnphSPai3JYkZ5FRtbw
         bNE1ILRpooxdUha0mwXxhegJcmuE8Z1VfAcpgB1ZTJj/qY/dO+tLEPkKHiY8g3HjZnrT
         6gxGxqdGmF8dnh5kQclmou+URAoFzo6xq2QiG3+iKyJTB8mOLSt1kOMjQAW/SafrDCwo
         5278mbuZY7q4aDhLFXnyMVLjS5yFLt23gk+wFrV7DDA80vi33RYQ/SpWNtTg70jrINsq
         s+4uT8nXes0rAvuI2jVNrdhEzUhlzgB8ySEoMiEBbdi8XenspLjyJwGRITXUsLgC8gth
         CCIA==
X-Gm-Message-State: AOAM531KlU8WLJ4om81gUy9n8CJIg01YbEJ7Bzvb1IFkQ55G4lrEALYW
        cBUjbBibpkmnBvrbmPgLuzvIPw==
X-Google-Smtp-Source: ABdhPJxcqYzZpw8hjWvx8wtyMAFaG+Ip962yojdp/B4kEz2Pn9lx52Qn4eX8lgw7zW26Sgpyf8s+nQ==
X-Received: by 2002:a05:6808:3c9:: with SMTP id o9mr4905862oie.20.1634828468846;
        Thu, 21 Oct 2021 08:01:08 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:783a:c43c:af64:c142:4db7:63ac])
        by smtp.gmail.com with ESMTPSA id w18sm1173833ott.29.2021.10.21.08.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:01:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     thehajime@gmail.com, zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        johannes.berg@intel.com, roger.pau@citrix.com,
        miquel.raynal@bootlin.com, jdike@addtoit.com,
        anton.ivanov@cambridgegreys.com, geert@linux-m68k.org,
        krisman@collabora.com, vigneshr@ti.com, richard@nod.at,
        hare@suse.de, jinpu.wang@ionos.com, jgross@suse.com,
        sstabellini@kernel.org, ulf.hansson@linaro.org, agk@redhat.com,
        linux-mtd@lists.infradead.org,
        Luis Chamberlain <mcgrof@kernel.org>, tj@kernel.org,
        colyli@suse.de, jejb@linux.ibm.com, chris.obbard@collabora.com,
        snitzer@redhat.com, boris.ostrovsky@oracle.com,
        kent.overstreet@gmail.com, martin.petersen@oracle.com
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        xen-devel@lists.xenproject.org, linux-um@lists.infradead.org,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
Subject: Re: (subset) [PATCH 0/9] block: reviewed add_disk() error handling set
Message-Id: <163482846658.50565.12530170761457767964.b4-ty@kernel.dk>
Date:   Thu, 21 Oct 2021 09:01:06 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 15 Oct 2021 16:30:19 -0700, Luis Chamberlain wrote:
> Jens,
> 
> I had last split up patches into 7 groups, but at this point now
> most changes are merged except a few more drivers. Instead of creating
> a new patch set for each of the 7 groups I'm creating 3 new groups of
> patches now:
> 
> [...]

Applied, thanks!

[3/9] dm: add add_disk() error handling
      commit: e7089f65dd51afeda5eb760506b5950d95f9ec29
[4/9] bcache: add error handling support for add_disk()
      commit: 2961c3bbcaec0ed7fb7b9a465b3796f37f2294e5
[5/9] xen-blkfront: add error handling support for add_disk()
      commit: 293a7c528803321479593d42d0898bb5a9769db1
[6/9] m68k/emu/nfblock: add error handling support for add_disk()
      commit: 21fd880d3da7564bab68979417cab7408e4f9642
[7/9] um/drivers/ubd_kern: add error handling support for add_disk()
      commit: 66638f163a2b5c5b462ca38525129b14a20117eb
[8/9] rnbd: add error handling support for add_disk()
      commit: 2e9e31bea01997450397d64da43b6675e0adb9e3
[9/9] mtd: add add_disk() error handling
      commit: 83b863f4a3f0de4ece7802d9121fed0c3e64145f

Best regards,
-- 
Jens Axboe


