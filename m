Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B632588A1E
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Aug 2022 12:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbiHCKGM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Aug 2022 06:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237799AbiHCKGI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Aug 2022 06:06:08 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED795CE15
        for <linux-bcache@vger.kernel.org>; Wed,  3 Aug 2022 03:06:06 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id i24so2423582qkg.13
        for <linux-bcache@vger.kernel.org>; Wed, 03 Aug 2022 03:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=OSmNM3YvqSEhvcoO4riEcTOu9Mbn71kFOhgq1x9XYYU=;
        b=Wdzlc3BdzgmiRNNWhA3fXnPJC5SKbALv3KRvbaaqshwaJsmfJ7mbsv4ctFGKfgMXkP
         7jIu+9VIG2sRlAhBCzK+UNOZTigMJaMlyRPbY4cA0rbwGoZ4SkFbCtH/eZNllBGf1T6q
         48NkYb3y/TumcpDIDwbnJjIgq9yDh7pZHiu8m/dhD81T0tdawPICYyJ9ATgCoiZjb4gh
         YGV9pwmkQz4ezxHokgfj+YBtPzjOR+GobGpuD81siuO5MDMgL+bwPKuYD4gcmfrCdeew
         AcmusGngSzQiolCBbhHHYoNo2SIm32/04TNIQecmp7T4WWDgb9oY/lUIJwKxnGVmnSXF
         42rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=OSmNM3YvqSEhvcoO4riEcTOu9Mbn71kFOhgq1x9XYYU=;
        b=AmnbQZSIMCBPwfJbRQkyKc+SvRalBbFYkwQfCBC+ZneBtEpEUqi5s4aH9q+c2CTbmp
         s1cXRycpPqYQVn4YoSQGwSbptDmicQgzIRb8SvQw6ucjn5HqvGC0u3XK2dpfuo1kEe2V
         iLGw1YamsC2hYd3lsLP1nrANPncqU5DTYtebDl1QyDFWdZanpdTf0fZ7BgaXUoebRQZg
         Rgdz3rNGRpK66BWmZqs/Y3UQ3MCTzHrqPXHvIomDIQsjLSLY6bxXb1kY/0uPhlKqnZ4h
         7t9iS1KphZyEpgaGIwfN2ELOo9aasMx1ZUlz1wThoVQ9WtjUedRQ1rLrJxxMgt+gZj/4
         qt4Q==
X-Gm-Message-State: AJIora9a/0wameDs/v+i/sGZNZw+pTB1iFJsYiEKxq5+9J/PViZg49MN
        nleXHj/83AkpKROnGq13tzKRLnlQOH+zg9u5IvWZ6g==
X-Google-Smtp-Source: AGRyM1vaGinehPht7+k7WLCIUFu+dsbhrH895mvr4Z9Frc1Cn3QE8PGOQbpOB0tHMXy/IqcgQsRkTpxoeCF+7mYgM+o=
X-Received: by 2002:a05:620a:1296:b0:6b5:cd9c:2fc9 with SMTP id
 w22-20020a05620a129600b006b5cd9c2fc9mr17903793qki.115.1659521166083; Wed, 03
 Aug 2022 03:06:06 -0700 (PDT)
MIME-Version: 1.0
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Wed, 3 Aug 2022 12:05:55 +0200
Message-ID: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
Subject: [RFC] Live resize of backing device
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,
In one of our previous emails you said that
> Currently bcache doesn=E2=80=99t support cache or backing device resize

I was investigating this point and I actually found a solution. I
briefly tested it and it seems to work fine.
Basically what I'm doing is:
  1. Check if there's any discrepancy between the nr of sectors
reported by the bcache backing device (holder) and the nr of sectors
reported by its parent (slave).
  2. If the number of sectors of the two devices are not the same,
then call set_capacity_and_notify on the bcache device.
  3. From user space, depending on the fs used, grow the fs with some
utility (e.g. xfs_growfs)

This works without any need of unmounting the mounted fs nor stopping
the bcache backing device.

 So my question is: am I missing something? Can this live resize cause
some problems (e.g. data loss)? Would it be useful if I send a patch
on this?

Kind regards,
Andrea
