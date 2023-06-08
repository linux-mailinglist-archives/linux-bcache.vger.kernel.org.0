Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53EC727A5B
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Jun 2023 10:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbjFHIrh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 8 Jun 2023 04:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbjFHIre (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2023 04:47:34 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEC2272A
        for <linux-bcache@vger.kernel.org>; Thu,  8 Jun 2023 01:47:31 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f6d7abe934so1827085e9.2
        for <linux-bcache@vger.kernel.org>; Thu, 08 Jun 2023 01:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20221208.gappssmtp.com; s=20221208; t=1686214050; x=1688806050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Z0zXMf0/p1bWmc9mPlzpLlXYRZkfsnJE7sT8NRRA6c=;
        b=vkzOBIDyJZnE5t4Mj6KFwse5JLCGNYhVpD7M+LgRRAMweH7g5OH2v9GR8Kjk+mPpJm
         NFJNzRyEA3IyKuvp7ODnGHL2Af5KJgwvRhzjwf+IFMbbs3Ted974+vGTeleHQR5SKwGb
         b51DB4GATQSJy7/aa6dVBWvtN1fKh3j+MsQqSLaL0gg8C7sUjIaXCDmas7Q82iLoi2Fi
         ugG3zDp2J/kj+Q3TNNSScGVCX2fMCwjdIX6YCNNx4q8YsyhkIaQSOa714CgWEa7Wuf3g
         xuWNdIeV51MWblNgszX4dDTQTNus8HSvkBuoP0iMTSy1oAvOKlY2L1m7f7ZPLQvrDhY6
         hPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686214050; x=1688806050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Z0zXMf0/p1bWmc9mPlzpLlXYRZkfsnJE7sT8NRRA6c=;
        b=Iev3oIZtWcVbnyUoXbuxMxuOLZcztA7DUo3KvAzDrcVDMS4FwElRORfZGD8gJ9AiVu
         mrbNP2+agTs7woOnjbFGQtcj4IU+MEO4uCrjh5HCDJnYcvWc8CBPKcZ00u7NYHVmm6cA
         aYhLT8qWnJQkZ+w9rF3wsKnyAELCymwobQ6Gm9lalzT63B2p4ynKBKWsbPJ6iCIEVReG
         fK27Xp9gasGLL7Iohe1gISYIIcs3N09uZ1XQisw9RcXqSsYWc7Y8Tx5bKVrMDlWZ841u
         720uGpW0DcPYD60M8o3tCiNjpAfaByPYC5NMcnmeq+ghd3eqAVcH6fxksZgLcS/7IIcU
         kp0g==
X-Gm-Message-State: AC+VfDzYGX7r23R1qOWfdGL/YG3RMi2KkvuIpqxM6f5N1OQ5bBfXY9V/
        rz+20zAT3vemSykOlOgJ7JLWxw==
X-Google-Smtp-Source: ACHHUZ64php+m1QCHow4PROIWkYJdsxvPRvM75l2Ndr3HzBRHztMsSyV31x82/mpTwubbqm80EXyLg==
X-Received: by 2002:a05:600c:d6:b0:3f6:389:73b1 with SMTP id u22-20020a05600c00d600b003f6038973b1mr839950wmm.6.1686214049725;
        Thu, 08 Jun 2023 01:47:29 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id n19-20020a7bcbd3000000b003f73a101f88sm1253740wmi.16.2023.06.08.01.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 01:47:29 -0700 (PDT)
Date:   Thu, 8 Jun 2023 09:47:27 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>,
        Josef Bacik <josef@toxicpanda.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@suse.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-um@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-btrfs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 06/31] cdrom: remove the unused mode argument to
 cdrom_release
Message-ID: <ZIGVn9E9ME26V0Gn@equinox>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-7-hch@lst.de>
 <ZH+6qd1W75G49P7p@equinox>
 <20230608084129.GA14689@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608084129.GA14689@lst.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jun 08, 2023 at 10:41:29AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 07, 2023 at 12:00:57AM +0100, Phillip Potter wrote:
> > Looks good, thanks.
> > 
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> 
> Hmm, these signoffs don't really make sense here.  Were they intended
> as Reviewed-bys?
> 
Hi Christoph,

Yes indeed - I was under the impression it was appropriate for a
maintainer to signal their approval of a patch to maintained code using
a Signed-off-by tag due to their involvement in the submission process?
Apologies if I've got this wrong, happy to send Reviewed-bys by all
means.

Regards,
Phil
